import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/petugas/widgets/petugas_navbar.dart';
import 'package:sipetir/petugas/halaman%20profil/profil_page.dart';
import 'package:sipetir/petugas/pengembalian_page.dart';
import 'package:sipetir/petugas/peminjaman_page.dart';
import 'package:sipetir/petugas/laporan/laporan_page.dart';
import 'package:intl/intl.dart';

class DashboardPetugasPage extends StatefulWidget {
  const DashboardPetugasPage({super.key});

  @override
  State<DashboardPetugasPage> createState() => _DashboardPetugasPageState();
}

class _DashboardPetugasPageState extends State<DashboardPetugasPage> {
  int _currentIndex = 0;
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Map<String, int>> _getStats() async {
    try {
      final userCount = await supabase.from('users').count(CountOption.exact);
      final alatCount = await supabase.from('Alat').count(CountOption.exact);
      return {
        'total_user': userCount,
        'total_alat': alatCount,
      };
    } catch (e) {
      debugPrint('Error stats: $e');
      return {'total_user': 0, 'total_alat': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      bottomNavigationBar: PetugasBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
          // Reset pencarian jika pindah halaman
          if (index != 0) _searchQuery = "";
        }),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const HeaderCustom(title: 'Dashboard', subtitle: 'Petugas'),
              Expanded(child: _buildBodyContent()),
            ],
          ),
          Positioned(
            top: 38,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilPage()),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.person_outline, color: Color(0xFFFF7A21)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (_currentIndex) {
      case 0: return _buildDashboardView();
      case 1: return const PeminjamanPage();
      case 2: return const PengembalianPage();
      case 3: return const LaporanPage(); // Menghubungkan ke halaman laporan
      default: return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, int>>(
              future: _getStats(),
              builder: (context, snapshot) {
                final stats = snapshot.data;
                return Row(
                  children: [
                    _buildSingleStat(Icons.people_alt_rounded, '${stats?['total_user'] ?? 0}', 'TOTAL USER'),
                    const SizedBox(width: 10),
                    _buildSingleStat(Icons.build_rounded, '${stats?['total_alat'] ?? 0}', 'TOTAL ALAT'),
                  ],
                );
              },
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Pemberitahuan Terbaru',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21)),
              ),
            ),
            const SizedBox(height: 15),
            _buildRealtimeStream(limit: 5),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRealtimeStream({int? limit}) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      // Menggunakan order descending agar yang terbaru muncul pertama
      stream: supabase
          .from('peminjaman')
          .stream(primaryKey: ['pinjam_id'])
          .order('tanggal_pinjam', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Tidak ada data peminjaman"),
          ));
        }

        var data = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          itemCount: limit != null && data.length > limit ? limit : data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            
            // Logic Filter Search berdasarkan User ID (Async di Card)
            return _buildItemCard(item);
          },
        );
      },
    );
  }

  Widget _buildItemCard(Map<String, dynamic> data) {
    String status = data['status'].toString().toLowerCase();
    String tgl = data['tanggal_pinjam'] != null 
        ? DateFormat('dd MMM yyyy').format(DateTime.parse(data['tanggal_pinjam'])) 
        : '-';

    return FutureBuilder<Map<String, dynamic>>(
      future: supabase.from('users').select('username').eq('id', data['user_id']).single(),
      builder: (context, userSnapshot) {
        String userName = userSnapshot.data?['username'] ?? 'Memuat...';

        // Filter UI: Jika ada query pencarian, sembunyikan card yang tidak cocok
        if (_searchQuery.isNotEmpty && !userName.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFB385)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(color: Color(0xFFFFE5D1), shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        userName != 'Memuat...' ? userName.substring(0, 1).toUpperCase() : '?',
                        style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        Text(data['tingkatan_kelas'] ?? '-', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                  Text(tgl, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 15),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: supabase.from('detail_peminjaman').select('Alat(nama_barang)').eq('pinjam_id', data['pinjam_id']),
                builder: (context, itemSnapshot) {
                  String namaBarang = itemSnapshot.hasData && itemSnapshot.data!.isNotEmpty 
                      ? itemSnapshot.data![0]['Alat']['nama_barang'] 
                      : 'Memuat barang...';
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                    decoration: BoxDecoration(color: const Color(0xFFFFE5D1).withOpacity(0.6), borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      namaBarang,
                      style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: status == 'disetujui' || status == 'dipinjam' 
                      ? const Color(0xFFFFE5D1) 
                      : (status == 'ditolak' ? const Color(0xFFFFD6D6) : const Color(0xFFF0F0F0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: status == 'disetujui' || status == 'dipinjam' 
                          ? const Color(0xFFFF7A21) 
                          : (status == 'ditolak' ? Colors.red : Colors.grey),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Cari Username',
        hintStyle: const TextStyle(color: Color(0xFFFFB385)),
        prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB385)),
        suffixIcon: _searchQuery.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.clear, color: Color(0xFFFFB385)),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = "");
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFFB385)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFF7A21), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSingleStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB385)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF7A21), size: 30),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}