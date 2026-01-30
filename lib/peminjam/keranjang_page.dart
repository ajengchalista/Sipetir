import 'package:flutter/material.dart';

class KeranjangPage extends StatelessWidget {
  const KeranjangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Keranjang Besar di Tengah
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(
                0xFFFFE5D1,
              ), // Warna background bulat soft orange
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_basket_rounded,
              size: 100,
              color: Color(0xFFFF7A21), // Warna ikon orange pekat
            ),
          ),
          const SizedBox(height: 25),
          // Teks Keterangan
          const Text(
            'Keranjang kosong,',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A4A4A),
            ),
          ),
          const Text(
            'belum ada alat yang dipilih',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }
}
