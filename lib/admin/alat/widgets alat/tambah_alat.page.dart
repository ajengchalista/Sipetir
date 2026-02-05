import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahAlatPage extends StatefulWidget {
  const TambahAlatPage({super.key});

  @override
  State<TambahAlatPage> createState() => _TambahAlatPageState();
}

class _TambahAlatPageState extends State<TambahAlatPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();

  String? _selectedKategoriId; // Sekarang menyimpan ID (UUID)
  List<Map<String, dynamic>> _listKategori =
      []; // Menampung hasil fetch dari DB
  bool _isLoadingKategori = true;

  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadKategoriDariDB(); // Ambil data saat dialog muncul
  }

  // MENGAMBIL DATA KATEGORI LANGSUNG DARI DATABASE
  Future<void> _loadKategoriDariDB() async {
    try {
      final data = await Supabase.instance.client
          .from('kategori')
          .select('kategori_id, nama_kategori')
          .order('nama_kategori');

      setState(() {
        _listKategori = List<Map<String, dynamic>>.from(data);
        _isLoadingKategori = false;
      });
    } catch (e) {
      debugPrint("Gagal ambil kategori: $e");
      if (mounted) setState(() => _isLoadingKategori = false);
    }
  }

  Future<void> _aksesGaleri() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Container(
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

              GestureDetector(
                onTap: _aksesGaleri,
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
                      child: _webImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                _webImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.image_search_outlined,
                              size: 40,
                              color: Colors.black45,
                            ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Klik untuk Upload Foto",
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

              Align(
                alignment: Alignment.centerLeft,
                child: _buildLabel("Kategori"),
              ),
              
              // Tampilkan loading jika data belum siap
              _isLoadingKategori 
                ? const LinearProgressIndicator() 
                : _buildDropdown(),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF58220)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                      onPressed: () {
                        if (_namaController.text.trim().isEmpty ||
                            _kodeController.text.trim().isEmpty ||
                            _selectedKategoriId == null) {
                          _showError("Semua data wajib diisi!");
                          return;
                        }

                        Navigator.pop(context, {
                          'nama': _namaController.text.trim(),
                          'kode': _kodeController.text.trim(),
                          'kategori_id': _selectedKategoriId,
                          'file_gambar': _webImage,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF58220),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildFieldSection(
    String label,
    String hint,
    TextEditingController controller,
  ) {
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFFBB074)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFF58220),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
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
          value: _selectedKategoriId,
          hint: const Text('Pilih Kategori'),
          isExpanded: true,
          items: _listKategori.map((kat) {
            return DropdownMenuItem<String>(
              value: kat['kategori_id'].toString(), // Nilai yang disimpan
              child: Text(kat['nama_kategori'].toString()), // Nama yang tampil
            );
          }).toList(),
          onChanged: (val) {
            setState(() => _selectedKategoriId = val);
          },
        ),
      ),
    );
  }
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
}
