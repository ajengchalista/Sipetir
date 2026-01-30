import 'package:flutter/material.dart';
import 'package:sipetir/petugas/laporan/laporan_page.dart';

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
      // Logika OnTap diperbaiki di sini
      onTap: (index) {
        if (index == 3) {
          // Jika tab Laporan (index 3) diklik, langsung pindah halaman
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LaporanPage()),
          );
        } else {
          // Jika tab lain, jalankan fungsi onTap bawaan (ganti index)
          onTap(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFFF7A21),
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
          icon: Icon(Icons.description_outlined),
          label: 'Laporan',
        ),
      ],
    );
  }
}
