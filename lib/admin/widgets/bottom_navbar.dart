import 'package:flutter/material.dart';

class AdminBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFFFF7A21),
      unselectedItemColor: Colors.grey,
      // 'fixed' menjaga posisi ikon dan label tetap di tempatnya
      type: BottomNavigationBarType.fixed, 
      currentIndex: currentIndex,
      onTap: onTap,
      // INI PERBAIKANNYA: Memaksa label tetap muncul di semua kondisi
      showSelectedLabels: true, 
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Daftar Alat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Peminjaman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_return),
          label: 'Pengembalian',
        ),
      ],
    );
  }
}