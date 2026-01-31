import 'package:flutter/material.dart';

class EditAlatPage extends StatefulWidget {
  final Map<String, String> data;

  const EditAlatPage({super.key, required this.data});

  @override
  State<EditAlatPage> createState() => _EditAlatPageState();
}

class _EditAlatPageState extends State<EditAlatPage> {
  late TextEditingController _namaController;
  late TextEditingController _kodeController;
  String? _selectedKategori;

  // Daftar kategori sesuai kebutuhan aplikasi
  final List<String> _kategoriList = [
    'Alat Ukur Listrik',
    'Peralatan Mekanik',
    'Alat Analisis & Quality check',
    'Keselamatan Kerja (K3)',
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data yang sudah ada
    _namaController = TextEditingController(text: widget.data['title']);
    _kodeController = TextEditingController(text: widget.data['itemCode']);
    _selectedKategori = widget.data['category'];
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Handle keyboard
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF9EFE5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Alat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0822D),
              ),
            ),
            const SizedBox(height: 20),

            // Input Nama Alat
            _buildLabel('Nama Alat'),
            _buildTextField(_namaController, 'Masukkan Nama Alat'),

            const SizedBox(height: 15),

            // Input Kode Alat
            _buildLabel('Kode Alat'),
            _buildTextField(_kodeController, 'Masukkan Kode Alat'),

            const SizedBox(height: 15),

            // Dropdown Kategori
            _buildLabel('Kategori'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orange.withOpacity(0.5)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedKategori,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
                  items: _kategoriList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedKategori = newValue;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Batal & Simpan
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Color(0xFFF0822D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Color(0xFFF0822D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 1. Validasi Input
                      if (_namaController.text.trim().isEmpty ||
                          _kodeController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Nama dan Kode alat tidak boleh kosong!',
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      // 2. Kirim data kembali ke halaman Manajemen Alat
                      Navigator.pop(context, {
                        'title': _namaController.text,
                        'itemCode': _kodeController.text,
                        'category':
                            _selectedKategori ?? widget.data['category']!,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xFFF0822D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
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
    );
  }

  // Widget Helper untuk Label
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Widget Helper untuk TextField
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.orange.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
