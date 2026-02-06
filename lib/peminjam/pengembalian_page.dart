import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isProcessing = false;

  // Fungsi format tanggal agar seragam
  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return "-";
    try {
      DateTime dt = DateTime.parse(dateTimeStr);
      return DateFormat('dd-MM-yyyy, HH:mm').format(dt);
    } catch (e) {
      return dateTimeStr;
    }
  }

  // Fungsi Inti: Mengubah status menjadi 'dikembalikan' (Menunggu konfirmasi petugas)
  Future<void> _prosesKembalikan(String pinjamId, List details) async {
    setState(() => _isProcessing = true);
    try {
      // 1. Update status di tabel peminjaman
      await supabase
          .from('peminjaman')
          .update({'status': 'dikembalikan'})
          .eq('pinjam_id', pinjamId);

      // 2. Update status barang di tabel Alat menjadi 'tersedia' kembali
      for (var detail in details) {
        final alatId = detail['barang_id'];
        await supabase
            .from('Alat')
            .update({'status_barang': 'tersedia'})
            .eq('alat_id', alatId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil mengajukan pengembalian!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = supabase.auth.currentUser!.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Informasi Pengembalian',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7A21),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            // MENGAMBIL DATA: 'disetujui' (dipinjam), 'dikembalikan' (nunggu petugas), 'kembali' (selesai)
            stream: supabase
                .from('peminjaman')
                .stream(primaryKey: ['pinjam_id'])
                .eq('user_id', userId)
                .order('tanggal_pinjam', ascending: false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filter status agar yang muncul hanya proses pengembalian saja
              final listPinjam = snapshot.data
                      ?.where((item) => 
                        item['status'] == 'disetujui' || 
                        item['status'] == 'dikembalikan' || 
                        item['status'] == 'kembali')
                      .toList() ?? [];

              if (listPinjam.isEmpty) {
                return const Center(
                  child: Text("Tidak ada alat dalam proses pengembalian."),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: listPinjam.length,
                itemBuilder: (context, index) {
                  final item = listPinjam[index];
                  
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: supabase.from('detail_peminjaman').select('''
                          barang_id,
                          Alat (nama_barang, kode_alat)
                        ''').eq('pinjam_id', item['pinjam_id']),
                    builder: (context, detailSnapshot) {
                      if (!detailSnapshot.hasData) return const SizedBox();
                      
                      final details = detailSnapshot.data!;
                      final namaAlat = details.isNotEmpty 
                          ? details[0]['Alat']['nama_barang'] 
                          : "Alat";
                      final kodeAlat = details.isNotEmpty 
                          ? details[0]['Alat']['kode_alat'] 
                          : "-";

                      // Logika Penentuan Label Status
                      String labelStatus = "DIPINJAM";
                      if(item['status'] == 'dikembalikan') labelStatus = "MENUNGGU KONFIRMASI";
                      if(item['status'] == 'kembali') labelStatus = "SUDAH KEMBALI";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildReturnCard(
                          pinjamId: item['pinjam_id'],
                          title: namaAlat,
                          code: kodeAlat,
                          borrowDate: _formatDateTime(item['tanggal_pinjam']),
                          returnDate: _formatDateTime(item['tanggal_kembali']),
                          status: labelStatus,
                          details: details,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReturnCard({
    required String pinjamId,
    required String title,
    required String code,
    required String borrowDate,
    required String returnDate,
    required String status,
    required List details,
  }) {
    // Tombol hanya aktif jika statusnya masih 'DIPINJAM'
    bool isStillBorrowed = status == "DIPINJAM";

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Kode Alat : $code', style: const TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: status == "SUDAH KEMBALI" ? Colors.green.shade50 : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: status == "SUDAH KEMBALI" ? Colors.green : const Color(0xFFFF7A21).withOpacity(0.5)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == "SUDAH KEMBALI" ? Colors.green : const Color(0xFFFF7A21),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDateRow(Icons.calendar_today_outlined, 'Tgl Pinjam : ', borrowDate, Colors.black),
          const SizedBox(height: 5),
          _buildDateRow(Icons.access_time_filled, 'Tgl Kembali : ', returnDate, isStillBorrowed ? Colors.red : Colors.grey),
          const SizedBox(height: 20),
          
          // Tombol Ajukan hanya tampil/aktif jika statusnya masih DIPINJAM
          if (isStillBorrowed)
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _prosesKembalikan(pinjamId, details),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A21),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Ajukan Pengembalian',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            )
          else
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Proses pengembalian selesai",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateRow(IconData icon, String label, String date, Color dateColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFFF7A21)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        Text(date, style: TextStyle(color: dateColor, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}