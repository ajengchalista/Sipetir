import 'package:flutter/material.dart';
import 'package:sipetir/peminjam/manajemen_peminjaman_page.dart';
import 'package:sipetir/peminjam/pengembalian_page.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/peminjam/widgets/bottom_navbar.dart';

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  int _currentIndex = 0;
  int _jumlahKeranjang = 0;

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _alatList = [
    {'title': 'Keselamatan Kerja (K3)', 'subtitle': '20 Alat'},
    {'title': 'Alat Ukur Listrik', 'subtitle': '12 Alat'},
    {'title': 'Peralatan Mekanik', 'subtitle': '8 Alat'},
    {'title': 'Alat Analisis & Quality Check', 'subtitle': '15 Alat'},
  ];

  List<Map<String, String>> _filteredAlatList = [];

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

  void _tambahKeranjang() {
    setState(() {
      _jumlahKeranjang += 1;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    switch (_currentIndex) {
      case 0:
        return const HeaderCustom(title: 'Dashboard', subtitle: 'Peminjam');
      case 1:
        return const HeaderCustom(title: 'Daftar Alat', subtitle: 'Peminjam');
      case 2:
        return const HeaderCustom(
          title: 'Manajemen Peminjaman',
          subtitle: 'Peminjam',
        );
      case 3:
        return const HeaderCustom(title: 'Pengembalian', subtitle: 'Peminjam');
      case 4:
        return const HeaderCustom(title: 'Keranjang', subtitle: 'Siap Pinjam');
      default:
        return const HeaderCustom(title: 'Dashboard', subtitle: 'Peminjam');
    }
  }

  Widget _buildBodyContent() {
    switch (_currentIndex) {
      case 0:
        return _buildMainDashboard();
      case 1:
        return DaftarAlatPage(onPinjam: _tambahKeranjang);
      case 2:
        return const PeminjamanContentView();
      case 3:
        return const PengembalianPage();
      case 4:
        return KeranjangPageWithoutAppBar(jumlah: _jumlahKeranjang);
      default:
        return _buildMainDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      bottomNavigationBar: PeminjamNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        jumlahKeranjang: _jumlahKeranjang, // badge di navbar
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
            _buildCategoryCards(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
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

  Widget _buildCategoryCards() {
    return Column(
      children: _filteredAlatList.map((alat) {
        return _buildCategoryCard(
          alat['subtitle']!.split(' ')[0],
          alat['title']!,
          alat['subtitle']!,
        );
      }).toList(),
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
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE5D1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                count,
                style: const TextStyle(
                  color: Color(0xFFFF7A21),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Color(0xFFFF7A21),
          ),
        ],
      ),
    );
  }
}

// ------------------ DAFTAR ALAT PAGE ------------------
class DaftarAlatPage extends StatefulWidget {
  final VoidCallback onPinjam;
  const DaftarAlatPage({super.key, required this.onPinjam});

  @override
  State<DaftarAlatPage> createState() => _DaftarAlatPageState();
}

class _DaftarAlatPageState extends State<DaftarAlatPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Alat',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7A21),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Nama Alat / kode alat',
                        hintStyle: const TextStyle(
                          color: Color(0xFFFFB385),
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFFFB385),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFB385),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5D1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFB385)),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Color(0xFFFF7A21),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildAlatCard('Sarung Tangan Listrik', 'Keselamatan Kerja (K3)'),
              _buildAlatCard('Megger (Insulation Tester)', 'Alat Ukur Listrik'),
              _buildAlatCard('Dial Indicator', 'Peralatan Mekanik'),
              _buildAlatCard('Kunci Torsi', 'Peralatan Mekanik'),
              _buildAlatCard('Watt Meter', 'Alat Ukur Listrik'),
              _buildAlatCard('pH Meter', 'Alat Analisis & Quality Check'),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlatCard(String nama, String kategori) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nama,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5D1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  kategori,
                  style: const TextStyle(
                    color: Color(0xFFFF7A21),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onPinjam,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5D1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFB385)),
                  ),
                  child: const Text(
                    'Pinjam',
                    style: TextStyle(
                      color: Color(0xFFFF7A21),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------ KERANJANG PAGE ------------------
class KeranjangPageWithoutAppBar extends StatelessWidget {
  final int jumlah;
  const KeranjangPageWithoutAppBar({super.key, this.jumlah = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 25),
            const Text(
              'Keranjang kosong,',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A4A4A),
              ),
            ),
            const Text(
              'belum ada alat yang dipilih',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
        if (jumlah > 0)
          Positioned(
            top: 0,
            right: 120,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$jumlah',
                style: const TextStyle(
                  color: Color(0xFFFFF1E6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
