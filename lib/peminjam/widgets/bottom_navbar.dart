import 'package:flutter/material.dart';

class PeminjamNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int jumlahKeranjang; // Pastikan ini digunakan

  const PeminjamNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.jumlahKeranjang,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex > 3 ? 0 : currentIndex, // Agar tidak error jika index 4 (keranjang)
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFF7A21),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Daftar Alat'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Peminjaman'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Pengembalian'),
          ],
        ),
        // Tombol Keranjang Orange dengan Badge
        Positioned(
          top: -30,
          child: GestureDetector(
            onTap: () => onTap(4), 
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5D1),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFF7A21), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_basket_outlined,
                    size: 35,
                    color: Color(0xFFFF7A21),
                  ),
                ),
                // Bulatan Angka (Badge)
                if (jumlahKeranjang > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 22,
                        minHeight: 22,
                      ),
                      child: Text(
                        '$jumlahKeranjang',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}