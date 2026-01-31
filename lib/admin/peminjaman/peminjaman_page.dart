import 'package:flutter/material.dart';
import 'package:sipetir/admin/halaman%20profil/profil_page.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/alat/alat_page.dart';
import 'package:sipetir/admin/pengembalian/pengembalian_page.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  // Index 2 karena 'Peminjaman' berada di urutan ketiga pada AdminBottomNavbar
  int _currentIndex = 2;

  void _onNavbarTapped(int index) {
    if (index == _currentIndex)
      return; // Jangan pindah jika sudah di halaman yang sama

    setState(() {
      _currentIndex = index;
    });

    // LOGIKA NAVIGASI AKTIF (Tanpa merubah UI)
    switch (index) {
      case 0:
        // Memanggil class dari dashboard_admin_page.dart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardAdminPage()),
        );
        break;
      case 1:
        // Memanggil class dari alat_page.dart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ManajemenAlatPage()),
        );
        break;
      case 2:
        // Sudah berada di halaman Peminjaman
        break;
      case 3:
        // Memanggil class dari pengembalian_page.dart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PengembalianPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Column(
        children: [
          Stack(
            children: [
              const HeaderCustom(title: 'Peminjaman', subtitle: 'admin'),
              Positioned(
                top: 50, // Menyesuaikan area status bar
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    // NAVIGASI KE HALAMAN PROFIL
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white24, // Efek transparan halus
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // --- SEARCH & TITLE ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Peminjaman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7A21),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari Nama Alat / kode alat',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.tune, color: Color(0xFFFF7A21)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- LIST CARD ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildBorrowCard(
                  id: '#pmjkla-001',
                  name: 'Brilian Restu',
                  kelas: 'XII',
                  tglPinjam: '22 Jan 2026',
                  tglKembali: '23 Jan 2026',
                  status: 'Dipinjam',
                  statusColor: const Color(0xFFFF7A21),
                ),
                _buildBorrowCard(
                  id: '#pmjkla-002',
                  name: 'Kun Fayakun',
                  kelas: 'XI',
                  tglPinjam: '22 Jan 2026',
                  tglKembali: '23 Jan 2026',
                  status: 'Terlambat',
                  statusColor: const Color(0xFFFF8A8A),
                ),
                const SizedBox(
                  height: 80,
                ), // Memberi ruang agar tidak tertutup navbar
              ],
            ),
          ),
        ],
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: AdminBottomNavbar(
            currentIndex: _currentIndex,
            onTap: _onNavbarTapped,
          ),
        ),
      ),
    );
  }

  static Widget _buildBorrowCard({
    required String id,
    required String name,
    required String kelas,
    required String tglPinjam,
    required String tglKembali,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                id,
                style: const TextStyle(color: Color(0xFFFF7A21), fontSize: 12),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(kelas, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pinjam: $tglPinjam',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Kembali: $tglKembali',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
