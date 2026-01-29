import 'package:flutter/material.dart';
import 'package:sipetir/admin/alat/alat_page.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/pengembalian/pengembalian_page.dart';
import 'package:sipetir/admin/users/manajemen_user.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/admin/kategori/kategori_screen.dart';
// 1. TAMBAHKAN IMPORT DISINI
import 'package:sipetir/admin/log aktivitas/log_aktivitas_page.dart'; 

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _currentIndex = 0;

  void _onNavTapped(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManajemenAlatPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PeminjamanPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PengembalianPage()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManajemenUserPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderCustom(title: 'Dashboard', subtitle: 'Admin'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statCard(icon: Icons.build, total: '18', label: 'TOTAL ALAT'),
                  const SizedBox(height: 15),
                  _statCard(icon: Icons.people, total: '180', label: 'TOTAL USER'),
                  const SizedBox(height: 25),
                  const Text(
                    'Akses Cepat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF7A21),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  _menuCard(
                    icon: Icons.person_outline,
                    title: 'User',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManajemenUserPage()),
                      );
                    },
                  ),

                  _menuCard(
                    icon: Icons.category_outlined,
                    title: 'Kategori',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const KategoriScreen()),
                      );
                    },
                  ),

                  // 2. BAGIAN YANG DISAMBUNGKAN KE LOG AKTIVITAS
                  _menuCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Log Aktivitas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LogAktivitasPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
      ),
    );
  }

  // ... (Widget _statCard dan _menuCard tetap sama seperti kodemu)
  Widget _statCard({required IconData icon, required String total, required String label}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB385)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF7A21), size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(total, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFB385)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF7A21)),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF7A21),
              ),
            ),
            const Spacer(),
            const Icon(Icons.more_horiz, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}