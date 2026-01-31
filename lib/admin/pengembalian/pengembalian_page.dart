import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/admin/alat/alat_page.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  int _currentIndex = 3;

  void _onNavTapped(int index) {
    if (_currentIndex == index) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardAdminPage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManajemenAlatPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PeminjamanPage()));
        break;
      case 3:
        break;
    }
  }

  // --- LOGIKA HAPUS DATA ---
  Future<void> _deleteData(dynamic id) async {
    try {
      await supabase.from('pengembalian').delete().eq('id', id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- DIALOG KONFIRMASI SESUAI GAMBAR ---
  void _showDeleteDialog(dynamic id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Anda yakin ingin menghapusnya?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF7A21)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Tidak", style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteData(id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A21),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text("Iya", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              const HeaderCustom(title: 'Pengembalian', subtitle: 'Admin'),
              Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilPage())),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                    child: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 35),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFF7A21).withOpacity(0.3)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Pengembalian',
                        hintStyle: TextStyle(color: const Color(0xFFFF7A21).withOpacity(.6)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFFF7A21)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                // REALTIME LIST DARI SUPABASE
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: supabase.from('pengembalian').stream(primaryKey: ['id']).order('id'),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A21)));
                      }
                      final data = snapshot.data!;
                      if (data.isEmpty) {
                        return const Center(child: Text("Belum ada data pengembalian"));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return PengembalianCard(
                            kode: item['kode_alat'] ?? '-',
                            nama: item['nama_barang'] ?? '-',
                            status: item['status_kondisi'] ?? 'Baik',
                            statusColor: (item['status_kondisi'] == 'Rusak') ? Colors.red : Colors.green,
                            denda: item['denda']?.toString() ?? 'Tanpa Denda',
                            tglKembali: item['tgl_kembali'] ?? '-',
                            onDelete: () => _showDeleteDialog(item['id']),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

class PengembalianCard extends StatelessWidget {
  final String kode, nama, status, denda, tglKembali;
  final Color statusColor;
  final VoidCallback onDelete;

  const PengembalianCard({
    super.key,
    required this.kode,
    required this.nama,
    required this.status,
    required this.statusColor,
    required this.denda,
    required this.tglKembali,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDE2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFF7A21).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(kode, style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(.2), borderRadius: BorderRadius.circular(10)),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Unit dikembalikan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tgl kembali", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(tglKembali, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(denda,
                  style: TextStyle(
                      color: denda.contains('Denda') || denda != 'Tanpa Denda' ? Colors.red : Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              Row(
                children: [
                  _actionIcon(Icons.visibility, const Color(0xFFFF7A21), () {}),
                  const SizedBox(width: 8),
                  _actionIcon(Icons.edit_outlined, const Color(0xFFFF7A21), () {}),
                  const SizedBox(width: 8),
                  _actionIcon(Icons.delete_outline, Colors.red, onDelete), // TRIGER DIALOG DISINI
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}