import 'package:flutter/material.dart';

class PeminjamNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PeminjamNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFF7A21),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Daftar Alat'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Peminjaman'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Pengembalian'),
          ],
        ),
        // Tombol Keranjang Orange di Tengah
        Positioned(
          top: -30,
          child: GestureDetector(
            onTap: () => onTap(4), // Index khusus keranjang
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5D1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF7A21), width: 2),
              ),
              child: const Icon(Icons.shopping_basket_outlined, 
                  size: 35, color: Color(0xFFFF7A21)),
            ),
          ),
        ),
      ],
    );
  }
}