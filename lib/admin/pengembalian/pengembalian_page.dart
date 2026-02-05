import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/admin/pengembalian/widgets/detail_pengembalian.dart';
import 'package:sipetir/admin/alat/alat_page.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'widgets/edit_pengembalian_dialog.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  int _currentIndex = 3;
  late Stream<List<Map<String, dynamic>>> _pengembalianStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  void _initStream() {
    // Kita simpan ke variabel agar bisa di-refresh manual
    _pengembalianStream = supabase
        .from('pengembalian')
        .stream(primaryKey: ['kembali_id'])
        .order('tanggal_kembali_asli', ascending: false);
  }

  void _onNavTapped(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdminPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ManajemenAlatPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PeminjamanPage()),
        );
        break;
    }
  }

  Future<void> _updatePengembalian(
    dynamic id,
    Map<String, dynamic> updates,
  ) async {
    try {
      await supabase.from('pengembalian').update(updates).eq('kembali_id', id);

      if (mounted) {
        Navigator.pop(context); // Tutup Dialog

        // REFRESH DISINI: Paksa stream inisialisasi ulang
        setState(() {
          _initStream();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteData(dynamic id) async {
    try {
      await supabase.from('pengembalian').delete().eq('kembali_id', id);

      if (mounted) {
        // REFRESH DISINI
        setState(() {
          _initStream();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditDialog(Map<String, dynamic> itemData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPengembalianDialog(
          data: itemData,
          onSave: _updatePengembalian,
        );
      },
    );
  }

  void _showDeleteDialog(dynamic id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: const Text(
          "Anda yakin ingin menghapusnya?",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteData(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Iya", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Column(
        children: [
          Stack(
            children: [
              const HeaderCustom(title: 'Pengembalian', subtitle: 'Admin'),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilPage()),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFFF7A21).withOpacity(0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value
                        .toLowerCase(); // Simpan input ke variabel
                  });
                },
                decoration: const InputDecoration(
                  hintText:
                      'Cari Berdasarkan ID atau Kondisi', // Hint lebih jelas
                  prefixIcon: Icon(Icons.search, color: Color(0xFFFF7A21)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
  child: StreamBuilder<List<Map<String, dynamic>>>(
    stream: _pengembalianStream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A21)));
      }

      // 1. Ambil data mentah dari snapshot (sebelumnya bernama 'data')
      final List<Map<String, dynamic>> rawData = snapshot.data ?? [];

      // 2. Filter data berdasarkan input di Search Bar
      final filteredData = rawData.where((item) {
        final pinjamId = item['pinjam_id']?.toString().toLowerCase() ?? "";
        final kondisi = item['kondisi_saat_dikembalikan']?.toString().toLowerCase() ?? "";
        
        // Cek apakah query ada di dalam pinjam_id atau kondisi
        return pinjamId.contains(_searchQuery) || kondisi.contains(_searchQuery);
      }).toList();

      if (filteredData.isEmpty) {
        return const Center(child: Text("Data tidak ditemukan"));
      }

      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _initStream();
          });
        },
        color: const Color(0xFFFF7A21),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filteredData.length, // Gunakan hasil filter
          itemBuilder: (context, index) {
            final item = filteredData[index]; // Gunakan hasil filter
            return PengembalianCard(
              fullData: item,
              kode: "ID: ${item['pinjam_id']}",
              nama: "Alat Sipetir",
              status: item['kondisi_saat_dikembalikan'] ?? 'Baik',
              statusColor: (item['kondisi_saat_dikembalikan'] == 'Rusak') ? Colors.red : Colors.green,
              denda: (item['denda'] == null || item['denda'] == 0) ? 'Tanpa Denda' : 'Denda: Rp ${item['denda']}',
              tglKembali: item['tanggal_kembali_asli'] ?? '-',
              onDelete: () => _showDeleteDialog(item['kembali_id']),
              onEdit: () => _showEditDialog(item),
            );
          },
        ),
      );
    },
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
  final VoidCallback onDelete, onEdit;
  final Map<String, dynamic> fullData;

  const PengembalianCard({
    super.key,
    required this.kode,
    required this.nama,
    required this.status,
    required this.statusColor,
    required this.denda,
    required this.tglKembali,
    required this.onDelete,
    required this.onEdit,
    required this.fullData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF7A21).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  kode,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFFF7A21),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Unit dikembalikan",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Tgl kembali",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    Text(
                      tglKembali,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  denda,
                  style: TextStyle(
                    color: denda.contains('Rp 0') || denda == 'Tanpa Denda'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  _actionIcon(Icons.visibility, const Color(0xFFFF7A21), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPengembalianPage(item: fullData),
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  _actionIcon(
                    Icons.edit_outlined,
                    const Color(0xFFFF7A21),
                    onEdit,
                  ),
                  const SizedBox(width: 8),
                  _actionIcon(Icons.delete_outline, Colors.red, onDelete),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
