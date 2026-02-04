import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahAlatPage extends StatefulWidget {
  const TambahAlatPage({super.key});

  @override
  State<TambahAlatPage> createState() => _TambahAlatPageState();
}

class _TambahAlatPageState extends State<TambahAlatPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();

  // Biarkan null di awal untuk memicu 'hint' pada dropdown
  String? _selectedKategori;

  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  // Mapping Teks Kategori ke ID Tabel Supabase (UUID format)
  // ID ini diambil langsung dari hasil query database kamu sebelumnya
  final Map<String, String> _kategoriMap = {
    'Alat Ukur Listrik': '21dc896c-e711-40dd-99c8-d235b3fb9da5',
    'Peralatan Mekanik': 'b601e62e-9ec6-414c-9347-a8d85d04f9da',
    'Alat Analisis': '39024758-ca40-4da2-9135-e6ca8d037ab0',
    'K3': '9ffc65e6-785b-4fe5-af63-8873cb382717',
  };

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

              _buildFieldSection(
                "Nama Alat",
                "Masukkan nama alat",
                _namaController,
              ),
              const SizedBox(height: 15),
              _buildFieldSection(
                "Kode Alat",
                "Masukkan kode alat",
                _kodeController,
              ),
              const SizedBox(height: 15),

              Align(
                alignment: Alignment.centerLeft,
                child: _buildLabel("Kategori"),
              ),
              _buildDropdown(),

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
                            _selectedKategori == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Semua data (Nama, Kode, Kategori) wajib diisi!",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context, {
                          'nama': _namaController.text.trim(),
                          'kode': _kodeController.text.trim(),
                          'kategori_id': _kategoriMap[_selectedKategori],
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
          value: _selectedKategori,
          hint: const Text('Pilih Kategori'),
          isExpanded: true,
          items: _kategoriMap.keys
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: (val) {
            setState(() => _selectedKategori = val);
          },
        ),
      ),
    );
  }
}
