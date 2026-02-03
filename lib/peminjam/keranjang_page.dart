import 'package:flutter/material.dart';

class KeranjangPage extends StatelessWidget {
  final int keranjangCount;
  const KeranjangPage({super.key, required this.keranjangCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EB),
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(
            color: Color(0xFF4A4A4A),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFFFE5D1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF7A21)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon keranjang besar dengan badge
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE5D1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_basket_rounded,
                    size: 100,
                    color: Color(0xFFFF7A21),
                  ),
                ),
                if (keranjangCount > 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$keranjangCount',
                      style: const TextStyle(
                        color: Color(0xFFFFE5D1),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 25),
            // Teks keterangan
            Text(
              keranjangCount > 0
                  ? 'Ada $keranjangCount alat di keranjang'
                  : 'Keranjang kosong,\nbelum ada alat yang dipilih',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
