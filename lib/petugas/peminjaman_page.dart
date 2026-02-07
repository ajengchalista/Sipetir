import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> with SingleTickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller untuk 3 tab
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fungsi untuk update status dan pindah tab
  Future<void> _updateStatus(String id, String statusBaru) async {
    try {
      await supabase.from('peminjaman').update({'status': statusBaru}).eq('pinjam_id', id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Peminjaman berhasil diupdate ke $statusBaru'),
            backgroundColor: statusBaru == 'dipinjam' ? Colors.green : Colors.red,
          ),
        );

        // Berpindah tab otomatis: 1 untuk 'dipinjam', 2 untuk 'ditolak'
        _tabController.animateTo(statusBaru == 'dipinjam' ? 1 : 2);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui status')),
        );
      }
    }
  }

  // Dialog Konfirmasi
  void _showConfirmDialog(String id, String statusTujuan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Apakah Anda yakin ingin ${statusTujuan == 'dipinjam' ? 'menyetujui' : 'menolak'} peminjaman ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(id, statusTujuan);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: statusTujuan == 'dipinjam' ? Colors.green : Colors.red,
            ),
            child: const Text('Ya, Lanjutkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Persetujuan Peminjaman',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7A21))),
          ),
        ),
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFF7A21),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF2E4053),
          tabs: const [
            Tab(text: 'Menunggu'),
            Tab(text: 'Disetujui'), // Akan menampilkan status 'dipinjam'
            Tab(text: 'Ditolak')
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRealtimeStream(statusFilter: 'menunggu'),
              _buildRealtimeStream(statusFilter: 'dipinjam'),
              _buildRealtimeStream(statusFilter: 'ditolak'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRealtimeStream({required String statusFilter}) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      // Menggunakan stream realtime Supabase
      stream: supabase
          .from('peminjaman')
          .stream(primaryKey: ['pinjam_id'])
          .order('tanggal_pinjam', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data"));
        }

        // Filter data berdasarkan status di sisi client
        final data = snapshot.data!
            .where((item) => item['status'].toString().toLowerCase() == statusFilter.toLowerCase())
            .toList();

        if (data.isEmpty) return const Center(child: Text("Data kosong"));

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: data.length,
          itemBuilder: (context, index) => _buildItemCard(data[index], showButtons: statusFilter == 'menunggu'),
        );
      },
    );
  }

  Widget _buildItemCard(Map<String, dynamic> data, {bool showButtons = false}) {
    String status = data['status'].toString().toLowerCase();
    String tgl = data['tanggal_pinjam'] != null 
        ? DateFormat('dd MMM yyyy').format(DateTime.parse(data['tanggal_pinjam'])) 
        : '-';

    return FutureBuilder<Map<String, dynamic>>(
      // Mengambil data username dari tabel users
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
                    child: Center(child: Text(userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : '?', style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold, fontSize: 18))),
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
              
              // Menampilkan barang dari tabel detail_peminjaman join Alat
              FutureBuilder<List<Map<String, dynamic>>>(
                future: supabase.from('detail_peminjaman').select('Alat(nama_barang)').eq('pinjam_id', data['pinjam_id']),
                builder: (context, itemSnapshot) {
                  String namaBarang = (itemSnapshot.hasData && itemSnapshot.data!.isNotEmpty)
                      ? itemSnapshot.data![0]['Alat']['nama_barang'] 
                      : 'Memuat barang...';
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                    decoration: BoxDecoration(color: const Color(0xFFFFE5D1).withOpacity(0.6), borderRadius: BorderRadius.circular(15)),
                    child: Text(namaBarang, style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)),
                  );
                },
              ),
              const SizedBox(height: 15),
              
              if (showButtons) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showConfirmDialog(data['pinjam_id'], 'ditolak'), 
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)), 
                        child: const Text('Tolak', style: TextStyle(color: Colors.red))
                      )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showConfirmDialog(data['pinjam_id'], 'dipinjam'), 
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A21), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)), 
                        child: const Text('Setujui', style: TextStyle(color: Colors.white))
                      )
                    ),
                  ],
                )
              ] else ...[
                Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: status == 'dipinjam' ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE), 
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Center(
                    child: Text(
                      status == 'dipinjam' ? 'DISETUJUI (DIPINJAM)' : status.toUpperCase(), 
                      style: TextStyle(
                        color: status == 'dipinjam' ? Colors.green : Colors.red, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 13
                      )
                    )
                  ),
                )
              ]
            ],
          ),
        );
      },
    );
  }
}