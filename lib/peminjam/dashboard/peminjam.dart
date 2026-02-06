import 'package:flutter/material.dart';
import 'package:sipetir/peminjam/daftar_alat_page.dart';
import 'package:sipetir/peminjam/manajemen_peminjaman_page.dart';
import 'package:sipetir/peminjam/pengembalian_page.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/peminjam/widgets/bottom_navbar.dart';
import '../keranjang_page.dart';

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _alatList = [
    {'title': 'Keselamatan Kerja (K3)', 'subtitle': '20 Alat'},
    {'title': 'Alat Ukur Listrik', 'subtitle': '12 Alat'},
    {'title': 'Peralatan Mekanik', 'subtitle': '8 Alat'},
    {'title': 'Alat Analisis & Quality Check', 'subtitle': '15 Alat'},
  ];

  List<Map<String, String>> _filteredAlatList = [];
  List<Map<String, dynamic>> _keranjangItems = [];

  @override
  void initState() {
    super.initState();
    _filteredAlatList = List.from(_alatList);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAlatList = _alatList
          .where((alat) => alat['title']!.toLowerCase().contains(query))
          .toList();
    });
  }

  void _tambahKeKeranjang(Map<String, dynamic> alat) {
    setState(() {
      bool sudahAda = _keranjangItems.any(
        (item) => item['nama_barang'] == alat['nama_barang'],
      );
      if (!sudahAda) {
        _keranjangItems.add(alat);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${alat['nama_barang']} ditambah ke keranjang'),
            backgroundColor: const Color(0xFFFF7A21),
          ),
        );
      }
    });
  }

  void _bersihkanKeranjang() {
    setState(() => _keranjangItems.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFDF1E9,
      ), // Warna background krem sesuai gambar
      bottomNavigationBar: PeminjamNavbar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        jumlahKeranjang: _keranjangItems.length,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBodyContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    switch (_currentIndex) {
      case 1:
        return const HeaderCustom(title: 'Daftar Alat', subtitle: 'Peminjam');
      case 2:
        return const HeaderCustom(title: 'Peminjaman', subtitle: 'Peminjam');
      case 3:
        return const HeaderCustom(title: 'Pengembalian', subtitle: 'Peminjam');
      case 4:
        return const HeaderCustom(title: 'Keranjang', subtitle: 'Siap Pinjam');
      default:
        return const HeaderCustom(title: 'Dashboard', subtitle: 'Peminjam');
    }
  }

  // Pastikan urutan case sesuai dengan urutan icon di Bottom Navbar kamu
  Widget _buildBodyContent() {
    switch (_currentIndex) {
      case 0:
        return _buildMainDashboard(); // Dashboard Utama
      case 1:
        return DaftarAlatPage(onTambahKeranjang: _tambahKeKeranjang);
      case 2:
        return const PeminjamanContentView();
      case 3:
        return const PengembalianPage();
      case 4:
        // Pastikan index 4 adalah index Keranjang di PeminjamNavbar kamu
        return KeranjangPage(
          keranjangItems: _keranjangItems,
          onClear: () {
            setState(() {
              // Ganti listKeranjang menjadi _keranjangItems
              _keranjangItems.clear();

              // Reset ke Dashboard agar Navbar kembali ke posisi awal
              _currentIndex = 0;
            });
          },
        );
      default:
        return _buildMainDashboard();
    }
  }

  // --- DASHBOARD UTAMA SESUAI GAMBAR ---
  Widget _buildMainDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          // Row Statistik: Total User & Total Alat
          Row(
            children: [
              _buildStatCard(Icons.people_outline, '180', 'TOTAL USER'),
              const SizedBox(width: 15),
              _buildStatCard(Icons.build_outlined, '18', 'TOTAL ALA WKT'),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Kategori Alat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7A21),
            ),
          ),
          const SizedBox(height: 15),
          // List Kategori
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredAlatList.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(_filteredAlatList[index]['title']!);
            },
          ),
          const SizedBox(height: 100), // Space untuk Navbar
        ],
      ),
    );
  }

  // Widget Kartu Statistik (User/Alat)
  Widget _buildStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF7A21), size: 35),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7A21),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget Kartu Kategori Alat
  Widget _buildCategoryCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF7A21),
        ),
      ),
    );
  }
}
