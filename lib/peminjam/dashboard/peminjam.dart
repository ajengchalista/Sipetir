import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/peminjam/daftar_alat_page.dart';
import 'package:sipetir/peminjam/pengembalian_page.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/peminjam/widgets/bottom_navbar.dart';
import 'package:sipetir/peminjam/keranjang_page.dart';
import '../halaman profil/profil_page.dart';

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  int _currentIndex = 0;
  final SupabaseClient supabase = Supabase.instance.client;

  // Data kategori statis (Bisa diganti dengan fetch dari table kategori jika perlu)
  final List<Map<String, String>> _alatList = [
    {'title': 'Keselamatan Kerja (K3)', 'subtitle': 'Alat Perlindungan Diri'},
    {'title': 'Alat Ukur Listrik', 'subtitle': 'Multimeter, Oscilloscope'},
    {'title': 'Peralatan Mekanik', 'subtitle': 'Kunci Pas, Bor, Obeng'},
    {'title': 'Alat Analisis & QC', 'subtitle': 'Alat Uji Mutu'},
  ];

  List<Map<String, dynamic>> _keranjangItems = [];

  // Fungsi fetch data statistik
  Future<Map<String, int>> _getRealtimeStats() async {
    try {
      final userCount = await supabase.from('users').count(CountOption.exact);
      final alatCount = await supabase.from('Alat').count(CountOption.exact);
      return {'total_user': userCount, 'total_alat': alatCount};
    } catch (e) {
      return {'total_user': 0, 'total_alat': 0};
    }
  }

  void _tambahKeKeranjang(Map<String, dynamic> alat) {
    setState(() {
      bool sudahAda = _keranjangItems.any(
        (item) => item['alat_id'] == alat['alat_id'],
      );
      if (!sudahAda) {
        _keranjangItems.add(alat);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${alat['nama_barang']} ditambah ke keranjang'),
            backgroundColor: const Color(0xFFFF7A21),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alat sudah ada di keranjang')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E9),
      bottomNavigationBar: PeminjamNavbar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        jumlahKeranjang: _keranjangItems.length,
      ),
      body: Stack(
        children: [
          // Background & Content
          Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildBodyContent()),
            ],
          ),
          
          // Tombol Profil (Overlay di atas Header)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilPage()),
              ),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)
                  ],
                ),
                child: const Icon(Icons.person_outline, color: Color(0xFFFF7A21), size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String title = 'Dashboard';
    String subtitle = 'Peminjam';

    switch (_currentIndex) {
      case 1: title = 'Daftar Alat'; break;
      case 2: title = 'Keranjang'; break;
      case 3: title = 'Pengembalian'; break;
      case 4: title = 'Status Pinjam'; subtitle = 'Riwayat'; break;
    }

    return HeaderCustom(title: title, subtitle: subtitle);
  }

  Widget _buildBodyContent() {
    switch (_currentIndex) {
      case 0: return _buildMainDashboard();
      case 1: return DaftarAlatPage(onTambahKeranjang: _tambahKeKeranjang);
      case 2:
        return KeranjangPage(
          keranjangItems: _keranjangItems,
          onClear: () {
            setState(() {
              _keranjangItems.clear();
              _currentIndex = 4; // Pindah ke riwayat setelah checkout
            });
          },
        );
      case 3: return const PengembalianPage();
      case 4: return const PeminjamanContentView();
      default: return _buildMainDashboard();
    }
  }

  Widget _buildMainDashboard() {
    return RefreshIndicator(
      color: const Color(0xFFFF7A21),
      onRefresh: () async => setState(() {}),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            FutureBuilder<Map<String, int>>(
              future: _getRealtimeStats(),
              builder: (context, snapshot) {
                final stats = snapshot.data;
                return Row(
                  children: [
                    _buildStatCard(Icons.people_outline, '${stats?['total_user'] ?? 0}', 'TOTAL USER'),
                    const SizedBox(width: 15),
                    _buildStatCard(Icons.build_outlined, '${stats?['total_alat'] ?? 0}', 'TOTAL ALAT'),
                  ],
                );
              },
            ),
            const SizedBox(height: 35),
            const Text(
              'Kategori Alat',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21)),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _alatList.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(_alatList[index]['title']!, _alatList[index]['subtitle']!);
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF7A21), size: 30),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
                Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF7A21)),
        onTap: () => setState(() => _currentIndex = 1), // Arahkan ke Daftar Alat
      ),
    );
  }
}

// ================= TAMPILAN MONITORING STATUS PEMINJAM (Case 4) =================
class PeminjamanContentView extends StatelessWidget {
  const PeminjamanContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return const Center(child: Text("Silakan login kembali"));

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase
          .from('peminjaman')
          .stream(primaryKey: ['pinjam_id'])
          .eq('user_id', userId)
          .order('tanggal_pinjam', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A21)));
        }
        
        final data = snapshot.data ?? [];
        if (data.isEmpty) return const Center(child: Text("Belum ada riwayat peminjaman"));

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final status = item['status'].toString().toLowerCase();

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFFFE5D1),
                        child: const Icon(Icons.history, color: Color(0xFFFF7A21)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['kode_peminjaman'] ?? 'No Code', 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Kelas: ${item['tingkatan_kelas'] ?? '-'}", 
                                style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      _buildStatusBadge(status),
                    ],
                  ),
                  const Divider(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Status Akhir:", style: TextStyle(fontSize: 13, color: Colors.grey)),
                      Text(item['status'].toString().toUpperCase(), 
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: _getStatusColor(status)
                          )),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'disetujui' || status == 'dikembalikan') return Colors.green;
    if (status == 'ditolak') return Colors.red;
    return Colors.orange;
  }

  Widget _buildStatusBadge(String status) {
    IconData icon;
    Color color;
    if (status == 'disetujui' || status == 'dikembalikan') {
      icon = Icons.check_circle; color = Colors.green;
    } else if (status == 'ditolak') {
      icon = Icons.cancel; color = Colors.red;
    } else {
      icon = Icons.access_time_filled; color = Colors.orange;
    }
    return Icon(icon, color: color, size: 28);
  }
}