import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditAlatPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditAlatPage({super.key, required this.data});

  @override
  State<EditAlatPage> createState() => _EditAlatPageState();
}

class _EditAlatPageState extends State<EditAlatPage> {
  late TextEditingController namaController;
  late TextEditingController kodeController;

  final List<String> daftarKategori = [
    'Alat Ukur Listrik',
    'Peralatan Mekanik',
    'Alat Analisis & Quality Check',
    'Keselamatan Kerja (K3)',
  ];

  String? selectedKategori;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller
    namaController = TextEditingController(
      text: widget.data['nama_barang'] ?? widget.data['title'] ?? "",
    );
    kodeController = TextEditingController(
      text: widget.data['kode_alat'] ?? widget.data['itemCode'] ?? "",
    );

    // Ambil kategori awal secara aman
    String kategoriAwal = 'Alat Ukur Listrik';
    if (widget.data['kategori'] is Map) {
      kategoriAwal = widget.data['kategori']['nama_kategori'].toString();
    } else if (widget.data['category'] != null) {
      kategoriAwal = widget.data['category'].toString();
    } else if (widget.data['kategori'] != null) {
      kategoriAwal = widget.data['kategori'].toString();
    }

    selectedKategori = daftarKategori.contains(kategoriAwal)
        ? kategoriAwal
        : daftarKategori[0];
  }

  @override
  void dispose() {
    namaController.dispose();
    kodeController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    // Mencoba mengambil ID dari berbagai kemungkinan nama kunci
    final dynamic idAlat = widget.data['id'] ?? widget.data['id_alat'];

    if (idAlat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error: ID Alat tidak ditemukan di data awal!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final supabase = Supabase.instance.client;

      await supabase
          .from('alat') // Pastikan nama tabel ini sesuai di Supabase
          .update({
            'nama_barang': namaController.text,
            'kode_alat': kodeController.text,
            'kategori': selectedKategori,
          })
          .eq('id', idAlat);

      if (mounted) {
        Navigator.pop(context, true); // Kirim true agar halaman daftar refresh
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil memperbarui data")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFEE7D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Alat",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF58220),
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel("Nama Alat"),
              _buildTextField(controller: namaController),
              const SizedBox(height: 16),
              _buildLabel("Kode Alat"),
              _buildTextField(controller: kodeController),
              const SizedBox(height: 16),
              _buildLabel("Kategori"),
              _buildDropdown(),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFBB074)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Color(0xFFF58220)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updateData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF58220),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    ),
  );

  Widget _buildTextField({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFBB074)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF58220)),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFBB074)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedKategori,
          isExpanded: true,
          items: daftarKategori.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (val) {
            setState(() => selectedKategori = val);
          },
        ),
      ),
    );
  }
}
