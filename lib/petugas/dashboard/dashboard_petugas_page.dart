import 'package:flutter/material.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/petugas/widgets/petugas_navbar.dart';

class DashboardPetugasPage extends StatefulWidget {
  const DashboardPetugasPage({super.key});

  @override
  State<DashboardPetugasPage> createState() => _DashboardPetugasPageState();
}

class _DashboardPetugasPageState extends State<DashboardPetugasPage> {
  int _currentIndex = 0; // 0: Dash, 1: Pinjam, 2: Kembali, 3: Laporan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6), // Background krem
      bottomNavigationBar: PetugasBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Ganti halaman via navbar
          });
        },
      ),
      body: Column(
        children: [
          // Header Custom tetap di atas
          const HeaderCustom(title: 'Dashboard', subtitle: 'Petugas'),

          Expanded(child: _buildBodyContent()),
        ],
      ),
    );
  }

  // --- LOGIKA PERGANTIAN HALAMAN ---
  Widget _buildBodyContent() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardView();
      case 1:
        return _buildPeminjamanView();
      case 2:
        return _buildPengembalianView();
      case 3:
        return const Center(child: Text("Halaman Laporan (Coming Soon)"));
      default:
        return _buildDashboardView();
    }
  }

  // --- 1. TAMPILAN DASHBOARD (HOME) ---
  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildStatCards(),
          const SizedBox(height: 25),
          const Text(
            'Pemberitahuan Terbaru',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7A21),
            ),
          ),
          const SizedBox(height: 15),
          _buildGeneralCard(status: 'pending'), // Card tombol
          _buildGeneralCard(status: 'Disetujui'), // Card label orange
          _buildGeneralCard(
            status: 'Ditolak',
            reason: 'Alat sedang dalam perbaikan',
          ), // Card label merah
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 2. TAMPILAN PEMINJAMAN (TAB) ---
  Widget _buildPeminjamanView() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Persetujuan Peminjaman',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7A21),
                ),
              ),
            ),
          ),
          const TabBar(
            labelColor: Color(0xFFFF7A21),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2E4053),
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Menunggu'),
              Tab(text: 'Disetujui'),
              Tab(text: 'Ditolak'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTabList('pending'),
                _buildTabList('Disetujui'),
                _buildTabList('Ditolak'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. TAMPILAN PENGEMBALIAN ---
  Widget _buildPengembalianView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Daftar Pengembalian',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7A21),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 4,
            itemBuilder: (context, index) =>
                _buildGeneralCard(status: 'pengembalian'),
          ),
        ),
      ],
    );
  }

  // --- REUSABLE COMPONENTS (SEARCH, STATS, CARD) ---

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari Username',
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

  Widget _buildStatCards() {
    return Row(
      children: [
        _buildSingleStat(Icons.people_alt_rounded, '180', 'TOTAL USER'),
        const SizedBox(width: 15),
        _buildSingleStat(Icons.build_rounded, '18', 'TOTAL ALAT'),
      ],
    );
  }

  Widget _buildSingleStat(IconData icon, String value, String label) {
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
            Icon(icon, color: const Color(0xFFFF7A21), size: 40),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
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

  Widget _buildTabList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) => _buildGeneralCard(status: status),
    );
  }

  Widget _buildGeneralCard({required String status, String? reason}) {
    Color statusBgColor = const Color(0xFFFFE5D1);
    Color statusTextColor = const Color(0xFFFF7A21);

    if (status.toLowerCase() == 'ditolak') {
      statusBgColor = const Color(0xFFFFD6D6);
      statusTextColor = const Color(0xFFF44336);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE5D1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'AF',
                    style: TextStyle(
                      color: Color(0xFFFF7A21),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kun Fayakun',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'XII',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Text(
                '22 Jan 2026',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5D1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seragam APD K3',
                  style: TextStyle(
                    color: Color(0xFFFF7A21),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFFFF7A21),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // DINAMIS: Tombol atau Label Status
          if (status == 'pending')
            _buildActionButtons()
          else if (status == 'pengembalian')
            _buildReturnButton()
          else
            _buildStatusLabel(status, statusBgColor, statusTextColor, reason),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF7A21)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Tolak',
              style: TextStyle(color: Color(0xFFFF7A21)),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7A21),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Setujui', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildReturnButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7A21),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Konfirmasi Pengembalian',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatusLabel(
    String status,
    Color bg,
    Color text,
    String? reason,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              status,
              style: TextStyle(
                color: text,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (reason != null) ...[
          const SizedBox(height: 10),
          Text(
            reason,
            style: const TextStyle(
              color: Color(0xFFF44336),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
