import 'package:flutter/material.dart';

class DaftarAlatPage extends StatelessWidget {
  const DaftarAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Alat',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7A21),
                ),
              ),
              const SizedBox(height: 15),
              // Search Bar & Filter Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Nama Alat / kode alat',
                        hintStyle: const TextStyle(color: Color(0xFFFFB385), fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB385)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color(0xFFFFB385)),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5D1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFB385)),
                    ),
                    child: const Icon(Icons.tune, color: Color(0xFFFF7A21), size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // List Alat
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildAlatCard('Sarung Tangan Listrik', 'Keselamatan Kerja (K3)'),
              _buildAlatCard('Megger (Insulation Tester)', 'Alat Ukur Listrik'),
              _buildAlatCard('Dial Indicator', 'Peralatan Mekanik'),
              _buildAlatCard('Kunci Torsi', 'Peralatan Mekanik'),
              _buildAlatCard('Watt Meter', 'Alat Ukur Listrik'),
              _buildAlatCard('pH Meter', 'Alat Analisis & Quality Check'),
              const SizedBox(height: 100), // Space agar tidak tertutup navbar
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlatCard(String nama, String kategori) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Label Tersedia
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tersedia',
                style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF4A4A4A)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Label Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5D1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      kategori,
                      style: const TextStyle(color: Color(0xFFFF7A21), fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Tombol Pinjam
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5D1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFB385)),
                    ),
                    child: const Text(
                      'Pinjam',
                      style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}