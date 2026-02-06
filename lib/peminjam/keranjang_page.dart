import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class KeranjangPage extends StatefulWidget {
  final List<Map<String, dynamic>> keranjangItems;
  final VoidCallback onClear;

  const KeranjangPage({
    super.key,
    required this.keranjangItems,
    required this.onClear,
  });

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = false;

  final TextEditingController _tglPinjamController = TextEditingController();
  final TextEditingController _tglKembaliController = TextEditingController();

  // Controller Baru untuk Jam
  final TextEditingController _jamPinjamController = TextEditingController();
  final TextEditingController _jamKembaliController = TextEditingController();

  String? _selectedKelas;
  final List<String> _listKelas = ['X', 'XI', 'XII'];

  // Fungsi pilih Jam
  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF7A21),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _processCheckout() async {
    if (widget.keranjangItems.isEmpty) return;

    // Validasi semua field termasuk Jam
    if (_tglPinjamController.text.isEmpty ||
        _tglKembaliController.text.isEmpty ||
        _jamPinjamController.text.isEmpty ||
        _jamKembaliController.text.isEmpty ||
        _selectedKelas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lengkapi form peminjaman!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser!.id;

      // MENGGABUNGKAN Tanggal dan Jam untuk format Timestamp
      String fullPinjam =
          "${_tglPinjamController.text} ${_jamPinjamController.text}:00";
      String fullKembali =
          "${_tglKembaliController.text} ${_jamKembaliController.text}:00";

      // 1. Simpan ke tabel peminjaman (TANPA nama_siswa)
      // Cari bagian ini di fungsi _processCheckout
      final peminjaman = await supabase
          .from('peminjaman')
          .insert({
            'user_id': userId,
            'tanggal_pinjam': fullPinjam,
            'tanggal_kembali': fullKembali,
            'status': 'menunggu',
            'tingkatan_kelas': _selectedKelas,
          })
          .select()
          .single();

      final pinjamId = peminjaman['pinjam_id'];

      final details = widget.keranjangItems
          .map(
            (item) => {
              'pinjam_id': pinjamId,
              'barang_id': item['alat_id'], // Ini harus berisi UUID
              'jumlah': 1,
            },
          )
          .toList();

      await supabase.from('detail_peminjaman').insert(details);

      // 3. Update status alat
      for (var item in widget.keranjangItems) {
        await supabase
            .from('Alat')
            .update({'status_barang': 'dipinjam'})
            .eq('alat_id', item['alat_id']);
      }

      if (mounted) _showSuccessDialog();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 20),
            const Text(
              "Peminjaman Diajukan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              "Alat dan informasi Anda telah masuk ke riwayat peminjaman.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Di KeranjangPage, bagian _showSuccessDialog
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onClear();
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E9),
      body: widget.keranjangItems.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    _buildSectionTitle('Informasi Alat'),
                    const SizedBox(height: 15),
                    _buildAlatList(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Form Peminjaman'),
                    const SizedBox(height: 15),
                    _buildFormPeminjaman(),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFF7A21),
      ),
    );
  }

  Widget _buildAlatList() {
    return Column(
      children: widget.keranjangItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['nama_barang'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.keranjangItems.remove(item);
                      });
                    },
                  ),
                ],
              ),
              Text(
                'Kode Alat : ${item['kode_alat'] ?? 'N/A'}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFormPeminjaman() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kelas",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF1E9).withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFFFB385)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedKelas,
                hint: const Text("Pilih Kelas"),
                items: _listKelas
                    .map(
                      (String v) => DropdownMenuItem(value: v, child: Text(v)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedKelas = val),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Tgl Pinjam',
                  _tglPinjamController,
                  true,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildTextField(
                  'Tgl Kembali',
                  _tglKembaliController,
                  true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Jam Pinjam',
                  _jamPinjamController,
                  false,
                  isTime: true,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildTextField(
                  'Jam Kembali',
                  _jamKembaliController,
                  false,
                  isTime: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isDate, {
    bool isTime = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: isDate
              ? () => _selectDate(context, controller)
              : isTime
              ? () => _selectTime(context, controller)
              : null,
          decoration: InputDecoration(
            hintText: "Pilih",
            suffixIcon: Icon(
              isDate ? Icons.calendar_today : Icons.access_time,
              size: 18,
              color: const Color(0xFFFF7A21),
            ),
            filled: true,
            fillColor: const Color(0xFFFDF1E9).withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFFFB385)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFFF7A21)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _processCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7A21),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Ajukan Peminjaman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_rounded,
            size: 100,
            color: Colors.orange.shade200,
          ),
          const SizedBox(height: 20),
          const Text(
            "Keranjang kosong",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
