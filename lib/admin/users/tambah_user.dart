import 'package:flutter/material.dart';
import 'package:sipetir/admin/users/manajemen_user.dart';

class TambahUserDialog extends StatelessWidget {
  final Color orange;
  final Color bg;

  const TambahUserDialog({
    super.key,
    required this.orange,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bg, // Memanggil warna bg dari parameter
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      contentPadding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Tambah User Baru
            Text(
              'Tambah User Baru',
              style: TextStyle(
                color: orange, // Memanggil warna orange
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            // Input Fields
            _buildLabel("Nama Lengkap"),
            _buildTextField(),
            
            const SizedBox(height: 15),
            _buildLabel("Email"),
            _buildTextField(),

            const SizedBox(height: 15),
            _buildLabel("Password"),
            _buildTextField(isPassword: true),

            const SizedBox(height: 15),
            _buildLabel("Role"),
            _buildDropdownField(),

            const SizedBox(height: 35),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: orange),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(color: orange, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic simpan di sini
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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

  // Widget Helper untuk Label agar kode tidak duplikat
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  // Widget Helper untuk TextField
  Widget _buildTextField({bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFE8D6), // Warna input sesuai gambar
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: orange.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: orange),
        ),
      ),
    );
  }

  // Widget Helper untuk Dropdown Role
  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8D6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: orange.withOpacity(0.4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: orange),
          items: ['Admin', 'Petugas', 'Peminjam'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }
}