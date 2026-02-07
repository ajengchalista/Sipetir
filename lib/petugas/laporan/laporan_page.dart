import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  // State untuk filter - Default null artinya menampilkan semua data
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedKategori;
  String? _selectedStatus;
  List<Map<String, dynamic>> _kategoriList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  // Ambil daftar kategori untuk dropdown
  Future<void> _fetchKategori() async {
    try {
      final data = await supabase.from('kategori').select();
      setState(() {
        _kategoriList = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      debugPrint('Error fetch kategori: $e');
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked; else _endDate = picked;
      });
    }
  }

  // LOGIKA UTAMA: Query Supabase & Generate PDF
  Future<void> _generatePdfReport() async {
    setState(() => _isLoading = true);

    try {
      // 1. Membangun Query Dasar
      var query = supabase.from('peminjaman').select('''
        kode_peminjaman,
        tanggal_pinjam,
        tanggal_kembali,
        status,
        tingkatan_kelas,
        users(username),
        detail_peminjaman(
          Alat(nama_barang, kategori_id)
        )
      ''');

      // 2. Terapkan Filter Secara Kondisional (Hanya jika tidak null / bukan 'Semua')
      if (_startDate != null) {
        query = query.gte('tanggal_pinjam', DateTime(_startDate!.year, _startDate!.month, _startDate!.day).toIso8601String());
      }
      if (_endDate != null) {
        // Set ke akhir hari (23:59:59) agar data hari tersebut ikut terbawa
        query = query.lte('tanggal_pinjam', DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59).toIso8601String());
      }
      if (_selectedStatus != null && _selectedStatus != 'Semua') {
        query = query.eq('status', _selectedStatus!.toLowerCase());
      }

      final List<dynamic> data = await query.order('tanggal_pinjam', ascending: false);

      // 3. Filter Client-side untuk Kategori
      var filteredData = data;
      if (_selectedKategori != null && _selectedKategori != 'Semua') {
        filteredData = data.where((item) {
          final details = item['detail_peminjaman'] as List;
          return details.any((d) => d['Alat']['nama_barang'] == _selectedKategori);
        }).toList();
      }

      if (filteredData.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada data untuk periode/filter ini')),
          );
        }
        return;
      }

      // 4. Proses PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text('LAPORAN PEMINJAMAN ALAT', 
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Periode: ${_startDate != null ? DateFormat('dd/MM/yyyy').format(_startDate!) : 'Semua'} s/d ${_endDate != null ? DateFormat('dd/MM/yyyy').format(_endDate!) : 'Semua'}'),
              pw.Text('Status: ${_selectedStatus ?? 'Semua'} | Kategori: ${_selectedKategori ?? 'Semua'}'),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Kode', 'Peminjam', 'Barang', 'Tgl Pinjam', 'Status'],
                data: filteredData.map((item) {
                  final details = item['detail_peminjaman'] as List;
                  final namaBarang = details.isNotEmpty ? details[0]['Alat']['nama_barang'] : '-';
                  return [
                    item['kode_peminjaman'] ?? '-',
                    item['users']['username'] ?? '-',
                    namaBarang,
                    DateFormat('dd/MM/yy').format(DateTime.parse(item['tanggal_pinjam'])),
                    item['status'].toString().toUpperCase(),
                  ];
                }).toList(),
              ),
            ];
          },
        ),
      );

      // 5. Tampilkan Preview / Download
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());

    } catch (e) {
      debugPrint('Error PDF: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EB),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFF47521),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Laporan',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Form Filter Laporan',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21)),
                  ),
                  const SizedBox(height: 20),

                  // CARD FORM
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFB385)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Status Peminjaman'),
                        _buildDropdownField(
                          hint: 'Semua Status',
                          value: _selectedStatus,
                          items: ['Semua', 'Menunggu', 'Dipinjam', 'Disetujui', 'Dikembalikan', 'Ditolak'],
                          onChanged: (val) => setState(() => _selectedStatus = (val == 'Semua') ? null : val),
                        ),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Tgl Mulai'),
                                  _buildDateField(_startDate, () => _selectDate(context, true)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Tgl Akhir'),
                                  _buildDateField(_endDate, () => _selectDate(context, false)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        _buildLabel('Kategori Alat'),
                        _buildDropdownField(
                          hint: 'Semua Kategori',
                          value: _selectedKategori,
                          items: ['Semua', ..._kategoriList.map((e) => e['nama_kategori'].toString())],
                          onChanged: (val) => setState(() => _selectedKategori = (val == 'Semua') ? null : val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TOMBOL CETAK
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _generatePdfReport,
                      icon: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.print, color: Colors.white),
                      label: Text(
                        _isLoading ? 'Memproses...' : 'Cetak Sekarang (PDF)',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A21),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPERS
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF4A4A4A), fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint, 
    String? value, 
    required List<String> items, 
    required Function(String?) onChanged
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFF7A21)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateField(DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFB385)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Semua',
              style: const TextStyle(fontSize: 13),
            ),
            const Icon(Icons.calendar_today, size: 16, color: Color(0xFFFF7A21)),
          ],
        ),
      ),
    );
  }
}