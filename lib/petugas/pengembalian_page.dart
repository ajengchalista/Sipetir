import 'package:flutter/material.dart';


class PengembalianPage extends StatelessWidget {
  const PengembalianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- JUDUL HALAMAN ---
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Daftar Pengembalian',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7A21),
            ),
          ),
        ),

        // --- LIST CARD PENGEMBALIAN ---
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 4, // Sesuaikan dengan jumlah data
            itemBuilder: (context, index) {
              return _buildReturnCard();
            },
          ),
        ),
      ],
    );
  }

  // --- WIDGET HELPER: CARD PENGEMBALIAN (100% MIRIP GAMBAR) ---
  Widget _buildReturnCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)), // Border krem tua
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Profil (Avatar, Nama, Kelas, Tanggal)
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE5D1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'AF',
                    style: TextStyle(
                      color: Color(0xFFFF7A21),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kun Fayakun',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    Text(
                      'XII',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Text(
                '22 Jan 2026',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Container Nama Alat (Orange Muda)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5D1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seragam APD K3',
                  style: TextStyle(
                    color: Color(0xFFFF7A21),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFFFF7A21),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Tombol Konfirmasi (Orange Pekat)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan logika konfirmasi di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A21),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
              ),
              child: const Text(
                'Konfirmasi Pengembalian',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}