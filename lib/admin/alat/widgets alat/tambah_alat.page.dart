import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pastikan sudah tambah di pubspec.yaml

class TambahAlatPage extends StatefulWidget {
  const TambahAlatPage({super.key});

  @override
  State<TambahAlatPage> createState() => _TambahAlatPageState();
}

class _TambahAlatPageState extends State<TambahAlatPage> {
  // Controller untuk menangkap input teks
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();
  
  String _selectedKategori = 'Pilih Kategori';
  File? _image; // Variabel penampung file foto
  final ImagePicker _picker = ImagePicker();

  // --- FUNGSI INI UNTUK AKSES FILE GALERI ---
  Future<void> _aksesGaleri() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Membuka Galeri
        imageQuality: 80,           // Kompresi agar tidak terlalu berat
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Simpan path file ke variabel _image
        });
        debugPrint("Foto berhasil diambil: ${pickedFile.path}");
      }
    } catch (e) {
      debugPrint("Gagal akses galeri: $e");
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2E8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tambah Alat Baru",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF58220),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- AREA AKSES FILE (IMAGE PICKER) ---
                GestureDetector(
                  onTap: _aksesGaleri, // KETIKA DIPENCET AKAN AKSES FILE
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFFBB074)),
                        ),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(_image!, fit: BoxFit.cover), // Tampilkan foto yang dipilih
                              )
                            : const Icon(
                                Icons.image_search_outlined, // Icon berubah agar lebih intuitif
                                size: 40,
                                color: Colors.black45,
                              ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Klik untuk Upload Foto", // Tulisan diperjelas
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF58220),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                _buildFieldSection("Nama Alat", "Masukkan nama alat", _namaController),
                const SizedBox(height: 15),
                _buildFieldSection("Kode Alat", "Masukkan kode alat", _kodeController),
                const SizedBox(height: 15),

                Align(alignment: Alignment.centerLeft, child: _buildLabel("Kategori")),
                _buildDropdown(),
                const SizedBox(height: 30),

                // Tombol Batal & Simpan
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF58220)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Batal", style: TextStyle(color: Color(0xFFF58220))),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Kirim semua data balik ke halaman Manajemen Alat
                          Navigator.pop(context, {
                            'nama': _namaController.text,
                            'kode': _kodeController.text,
                            'kategori': _selectedKategori,
                            'file_gambar': _image,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF58220),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildFieldSection(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFFFF7F0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFFBB074)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFF58220), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F0),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFBB074)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedKategori == 'Pilih Kategori' ? null : _selectedKategori,
          hint: const Text('Pilih Kategori'),
          isExpanded: true,
          items: ['Alat Ukur Listrik', 'Peralatan Mekanik', 'Alat Analisis', 'K3']
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: (val) { if (val != null) setState(() => _selectedKategori = val); },
        ),
      ),
    );
  }
}