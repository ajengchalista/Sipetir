import 'package:flutter/material.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/peminjam/widgets/bottom_navbar.dart'; // Gunakan navbar peminjam
import 'package:sipetir/peminjam/daftar_alat_page.dart'; // Import halaman daftar alat

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  int _currentIndex = 0;

  // Fungsi untuk berpindah konten berdasarkan index navbar
  Widget _buildBodyContent() {
    switch (_currentIndex) {
      case 0:
        return _buildMainDashboard(); // Tampilan awal Dashboard
      case 1:
        return const DaftarAlatPage(); // Memanggil halaman Daftar Alat
      case 2:
        return const Center(child: Text("Halaman Peminjaman"));
      case 3:
        return const Center(child: Text("Halaman Pengembalian"));
      case 4:
        return const Center(child: Text("Halaman Keranjang")); // Index tombol tengah
      default:
        return _buildMainDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      // Menggunakan Navbar Peminjam yang ada keranjang melayangnya
      bottomNavigationBar: PeminjamNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: Column(
        children: [
          // Header tetap muncul di semua menu
          const HeaderCustom(title: 'Dashboard', subtitle: 'Peminjam'),
          
          // Konten berubah sesuai pilihan navbar
          Expanded(
            child: _buildBodyContent(),
          ),
        ],
      ),
    );
  }

  // --- TAMPILAN UTAMA DASHBOARD (INDEX 0) ---
  Widget _buildMainDashboard() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatCard(Icons.people_alt_rounded, '180', 'TOTAL USER'),
                const SizedBox(width: 15),
                _buildStatCard(Icons.build_rounded, '18', 'TOTAL ALAT'),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Kategori Alat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF7A21),
              ),
            ),
            const SizedBox(height: 15),
            _buildCategoryCard('40', 'Keselamatan Kerja (K3)', '20 Alat'),
            _buildCategoryCard('12', 'Alat Ukur Listrik', '12 Alat'),
            _buildCategoryCard('08', 'Peralatan Mekanik', '8 Alat'),
            _buildCategoryCard('15', 'Alat Analisis & Quality Check', '15 Alat'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS (SEARCH, STAT, CATEGORY) ---
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari Alat...',
        hintStyle: const TextStyle(color: Color(0xFFFFB385)),
        prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB385)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFFB385)),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB385)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF7A21), size: 35),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String count, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: const BoxDecoration(color: Color(0xFFFFE5D1), shape: BoxShape.circle),
            child: Center(child: Text(count, style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold, fontSize: 18))),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF4A4A4A))),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFFFF7A21)),
        ],
      ),
    );
  }
}