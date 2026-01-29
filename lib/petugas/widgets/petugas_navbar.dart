import 'package:flutter/material.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/petugas/widgets/petugas_navbar.dart';

class PetugasBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PetugasBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed, // Supaya label tetap muncul semua
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFFF7A21), // Orange sesuai gambar
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'Peminjaman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Pengembalian',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_toggle_off_rounded),
          label: 'Laporan',
        ),
      ],
    );
  }
}