import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/petugas/widgets/petugas_navbar.dart';
import 'package:sipetir/petugas/halaman profil/profil_page.dart';
import 'package:sipetir/petugas/pengembalian_page.dart';
import 'package:intl/intl.dart';

class DashboardPetugasPage extends StatefulWidget {
  const DashboardPetugasPage({super.key});

  @override
  State<DashboardPetugasPage> createState() => _DashboardPetugasPageState();
}

class _DashboardPetugasPageState extends State<DashboardPetugasPage> {
  int _currentIndex = 0;
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, int>> _getStats() async {
    try {
      final userCount = await supabase.from('users').count(CountOption.exact);
      final alatCount = await supabase.from('Alat').count(CountOption.exact);
      return {
        'total_user': userCount,
        'total_alat': alatCount,
      };
    } catch (e) {
      return {'total_user': 0, 'total_alat': 0};
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    try {
      await supabase.from('peminjaman').update({'status': status}).eq('pinjam_id', id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Peminjaman berhasil di-$status'),
            backgroundColor: status == 'disetujui' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui status')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      bottomNavigationBar: PetugasBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilPage())),
              child: Container(
                width: 40, height: 40,
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
      case 1: return _buildPeminjamanView();
      case 2: return _buildPengembalianView();
      case 3: return const Center(child: Text("Halaman Laporan (Coming Soon)"));
      default: return _buildDashboardView();
    }
  }

  // --- TAB 1: DASHBOARD ---
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FutureBuilder<Map<String, int>>(
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
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Pemberitahuan Terbaru', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
            ),
            const SizedBox(height: 15),
            _buildRealtimeStream(limit: 5, isDashboard: true), 
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: PEMINJAMAN ---
  Widget _buildPeminjamanView() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
              alignment: Alignment.centerLeft, 
              child: Text('Persetujuan Peminjaman', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21)))
            ),
          ),
          const TabBar(
            labelColor: Color(0xFFFF7A21),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2E4053),
            tabs: [Tab(text: 'Menunggu'), Tab(text: 'Disetujui'), Tab(text: 'Ditolak')],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildRealtimeStream(statusFilter: 'menunggu'),
                _buildRealtimeStream(statusFilter: 'disetujui'),
                _buildRealtimeStream(statusFilter: 'ditolak'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: PENGEMBALIAN (SUDAH DIPERBARUI) ---
  Widget _buildPengembalianView() {
    // Memanggil Class PengembalianPage yang sudah Anda buat sebelumnya
    return const PengembalianPage();
  }

  Widget _buildRealtimeStream({String? statusFilter, int? limit, bool isDashboard = false}) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase.from('peminjaman').stream(primaryKey: ['pinjam_id']).order('tanggal_pinjam'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var data = snapshot.data!;
        if (statusFilter != null) {
          data = data.where((item) => item['status'].toString().toLowerCase() == statusFilter.toLowerCase()).toList();
        }
        if (data.isEmpty) return const Center(child: Text("Tidak ada data"));
        int itemCount = limit != null && data.length > limit ? limit : data.length;
        return ListView.builder(
          shrinkWrap: isDashboard,
          physics: isDashboard ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          padding: isDashboard ? const EdgeInsets.symmetric(horizontal: 5) : const EdgeInsets.all(20), 
          itemCount: itemCount,
          itemBuilder: (context, index) => _buildItemCard(data[index], showButtons: !isDashboard && statusFilter == 'pending'),
        );
      },
    );
  }

  Widget _buildItemCard(Map<String, dynamic> data, {bool showButtons = false}) {
    String status = data['status'].toString().toLowerCase();
    String tgl = data['tanggal_pinjam'] != null 
        ? DateFormat('dd MMM yyyy').format(DateTime.parse(data['tanggal_pinjam'])) : '-';

    return FutureBuilder<Map<String, dynamic>>(
      future: supabase.from('users').select('username').eq('id', data['user_id']).single(),
      builder: (context, userSnapshot) {
        String userName = userSnapshot.data?['username'] ?? 'Memuat...';
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
                    width: 50, height: 50,
                    decoration: const BoxDecoration(color: Color(0xFFFFE5D1), shape: BoxShape.circle),
                    child: Center(child: Text(userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : '?', 
                      style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold, fontSize: 18))),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                decoration: BoxDecoration(color: const Color(0xFFFFE5D1).withOpacity(0.6), borderRadius: BorderRadius.circular(15)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Detail Barang', style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFF7A21)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              if (showButtons) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _updateStatus(data['pinjam_id'], 'ditolak'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF7A21)), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12)
                        ),
                        child: const Text('Tolak', style: TextStyle(color: Color(0xFFFF7A21))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateStatus(data['pinjam_id'], 'disetujui'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A21), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12)
                        ),
                        child: const Text('Setujui', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ] else ...[
                _buildStatusLabel(
                  status == 'disetujui' ? const Color(0xFFFFE5D1) : (status == 'ditolak' ? const Color(0xFFFFD6D6) : const Color(0xFFF0F0F0)),
                  status == 'disetujui' ? const Color(0xFFFF7A21) : (status == 'ditolak' ? Colors.red : Colors.grey),
                  status.toUpperCase()
                )
              ]
            ],
          ),
        );
      }
    );
  }

  Widget _buildStatusLabel(Color bg, Color text, String label) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Center(child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 13))),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari Username',
        hintStyle: const TextStyle(color: Color(0xFFFFB385)),
        prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB385)),
        filled: true, 
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), 
          borderSide: const BorderSide(color: Color(0xFFFFB385)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFF7A21), width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildSingleStat(IconData icon, String value, String label) {
    return Expanded(child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFB385))),
        child: Row(children: [
            Icon(icon, color: const Color(0xFFFF7A21), size: 30),
            const SizedBox(width: 8),
            Flexible(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
              ]),
            ),
        ]),
    ));
  }
}