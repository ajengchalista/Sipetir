import 'package:flutter/material.dart';

class TambahAlatPage extends StatelessWidget {
  const TambahAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan warna dari file warna Anda di sini, 
    // sementara saya gunakan hardcode sesuai gambar.
    const Color primaryOrange = Color(0xFFF0822D);
    const Color backgroundKrem = Color(0xFFFFF5ED);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: const BoxDecoration(
        color: backgroundKrem,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50), // Lengkungan dalam sesuai gambar
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tambah Alat Baru',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: primaryOrange,
            ),
          ),
          const SizedBox(height: 25),
          
          // Field Nama Alat
          _buildLabel("Nama Alat"),
          _buildTextField(primaryOrange),
          
          const SizedBox(height: 15),
          
          // Field Kode Alat
          _buildLabel("Kode Alat"),
          _buildTextField(primaryOrange),
          
          const SizedBox(height: 15),
          
          // Field Kategori (Dropdown)
          _buildLabel("Kategori"),
          _buildDropdownField(primaryOrange),
          
          const SizedBox(height: 35),
          
          // Row Tombol Batal & Simpan
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryOrange, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: primaryOrange, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Logic Insert/Simpan
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Widget Helper untuk Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  // Widget Helper untuk TextField
  Widget _buildTextField(Color color) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFDF7F2), // Sedikit lebih terang dari bg
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }

  // Widget Helper untuk Dropdown
  Widget _buildDropdownField(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7F2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down_rounded, color: color, size: 40),
          items: const [], // List kategori di sini
          onChanged: (value) {},
        ),
      ),
    );
  }
}