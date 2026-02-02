import 'package:flutter/material.dart';

class EditAlatPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const EditAlatPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Scaffold adalah kunci untuk menghilangkan error "No Material widget found"
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
        0.5,
      ), // Efek transparan belakang
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1E6), // Warna cream sesuai gambar
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Alat",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF58220),
                  ),
                ),
                const SizedBox(height: 20),

                // Form Field Nama Alat
                _buildLabel("Nama Alat"),
                _buildTextField(initialValue: data['title']),

                const SizedBox(height: 15),

                // Form Field Kode Alat
                _buildLabel("Kode Alat"),
                _buildTextField(initialValue: data['itemCode']),

                const SizedBox(height: 15),

                // Form Field Kategori
                _buildLabel("Kategori"),
                _buildDropdown(initialValue: data['category']),

                const SizedBox(height: 30),

                // Tombol Aksi
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFF58220),
                          side: const BorderSide(color: Color(0xFFFBB074)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Batal"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika simpan di sini
                          Navigator.pop(context);
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFBB074)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF58220), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown({String? initialValue}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFBB074)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: initialValue,
          isExpanded: true,
          items: [
            initialValue ?? 'Umum',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }
}
