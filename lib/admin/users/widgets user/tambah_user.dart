import 'package:flutter/material.dart';

class TambahAlatPage extends StatefulWidget {
  const TambahAlatPage({super.key, required Color orange, required Color bg});

  @override
  State<TambahAlatPage> createState() => _TambahAlatPageState();
}

class _TambahAlatPageState extends State<TambahAlatPage> {
  String _selectedKategori = 'Pilih Kategori';

  @override
  Widget build(BuildContext context) {
    // Gunakan Center agar widget berada di tengah layar saat showDialog dipanggil
    return Center(
      child: SingleChildScrollView(
        child: Material(
          color: Colors.transparent, // Agar background overlay tetap terlihat
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2E8), // Warna krem sesuai gambar
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Penting: agar container menyesuaikan tinggi konten
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tambah User Baru",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF58220),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel("Nama User"),
                _buildTextField("Masukkan nama user"),
                const SizedBox(height: 15),
                _buildLabel("Password"),
                _buildTextField("Masukkan Password"),
                const SizedBox(height: 15),
                _buildLabel("Kategori"),
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
                        onPressed: () => Navigator.pop(context, true),
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

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFFF7F0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F0),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFBB074)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedKategori == 'Pilih Kategori'
              ? null
              : _selectedKategori,
          hint: const Text('Pilih Kategori'),
          isExpanded: true,
          items: ['Admin', 'Petugas', 'Penyewa']
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: (val) => setState(() => _selectedKategori = val!),
        ),
      ),
    );
  }
}
