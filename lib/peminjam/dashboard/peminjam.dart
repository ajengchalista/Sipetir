import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/peminjam/daftar_alat_page.dart';
import 'package:sipetir/peminjam/pengembalian_page.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/peminjam/widgets/bottom_navbar.dart';
import 'package:sipetir/peminjam/manajemen_peminjaman_page.dart';
import '../keranjang_page.dart';

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  int _currentIndex = 0;
  final SupabaseClient supabase = Supabase.instance.client;
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

  Future<Map<String, int>> _getRealtimeStats() async {
    try {
      final userCount = await supabase.from('users').count(CountOption.exact);
      final alatCount = await supabase.from('Alat').count(CountOption.exact);
      return {'total_user': userCount, 'total_alat': alatCount};
    } catch (e) {
      return {'total_user': 0, 'total_alat': 0};
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E9),
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
      case 1: return const HeaderCustom(title: 'Daftar Alat', subtitle: 'Peminjam');
      case 2: return const HeaderCustom(title: 'Keranjang', subtitle: 'Peminjam');
      case 3: return const HeaderCustom(title: 'Pengembalian', subtitle: 'Peminjam');
      case 4: return const HeaderCustom(title: 'Status Pinjam', subtitle: 'Riwayat');
      default: return const HeaderCustom(title: 'Dashboard', subtitle: 'Peminjam');
    }
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
              _currentIndex = 4;
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
            const SizedBox(height: 30),
            const Text(
              'Kategori Alat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21)),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredAlatList.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(_filteredAlatList[index]['title']!);
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF7A21), size: 35),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
                Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFF7A21)),
        ],
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
      // Filter stream agar HANYA mengambil data milik user yang sedang login
      stream: supabase
          .from('peminjaman')
          .stream(primaryKey: ['pinjam_id'])
          .eq('user_id', userId) 
          .order('tanggal_pinjam'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final data = snapshot.data ?? [];
        
        if (data.isEmpty) {
          return const Center(child: Text("Belum ada riwayat peminjaman"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final status = item['status'].toString().toLowerCase();

            // Mengambil Nama User dari tabel users berdasarkan user_id
            return FutureBuilder<Map<String, dynamic>>(
              future: supabase.from('users').select('username').eq('id', userId).single(),
              builder: (context, userSnapshot) {
                String userName = userSnapshot.data?['username'] ?? 'Peminjam';

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFB385)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFFE5D1),
                          child: Text(userName.substring(0,1).toUpperCase(), 
                            style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)),
                        ),
                        title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Kelas: ${item['tingkatan_kelas'] ?? '-'}"),
                        trailing: _buildStatusIcon(status),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Status: ${item['status']}", 
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: status == 'disetujui' ? Colors.green : (status == 'ditolak' ? Colors.red : Colors.orange)
                            )),
                          Text(item['kode_peminjaman'] ?? '-', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                );
              }
            );
          },
        );
      },
    );
  }

  Widget _buildStatusIcon(String status) {
    if (status == 'disetujui') {
      return const Icon(Icons.check_circle, color: Colors.green, size: 30);
    } else if (status == 'ditolak') {
      return const Icon(Icons.cancel, color: Colors.red, size: 30);
    } else {
      return const Icon(Icons.access_time_filled, color: Colors.orange, size: 30);
    }
  }
}