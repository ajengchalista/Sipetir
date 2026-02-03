import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/admin/pengembalian/widgets/detail_pengembalian.dart';
import 'package:sipetir/admin/alat/alat_page.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';
import 'package:sipetir/widgets/header_custom.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  int _currentIndex = 3;
  late final Stream<List<Map<String, dynamic>>> _pengembalianStream;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengaktifkan stream realtime dari tabel pengembalian
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardAdminPage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManajemenAlatPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PeminjamanPage()));
        break;
    }
  }

  // --- FUNGSI UPDATE KE SUPABASE ---
  Future<void> _updatePengembalian(dynamic id, Map<String, dynamic> updates) async {
    try {
      await supabase.from('pengembalian').update(updates).eq('kembali_id', id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update Gagal: $e')));
    }
  }

  // --- FUNGSI DELETE DARI SUPABASE ---
  Future<void> _deleteData(dynamic id) async {
    try {
      await supabase.from('pengembalian').delete().eq('kembali_id', id);
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

  void _showDeleteDialog(dynamic id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Anda yakin ingin menghapusnya?", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF7A21)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text("Tidak", style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () { Navigator.pop(context); _deleteData(id); },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A21), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text("Iya", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isWide = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Column(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFF7A21).withOpacity(0.3)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari Pengembalian',
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
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A21)));
                      final data = snapshot.data!;
                      if (data.isEmpty) return const Center(child: Text("Belum ada data pengembalian"));

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 2 : 1,
                          childAspectRatio: isWide ? 1.8 : 2.1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 15,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return PengembalianCard(
                            fullData: item,
                            kode: item['pinjam_id']?.toString() ?? '-',
                            nama: item['nama_kategori_admin'] ?? 'Alat Sipetir',
                            status: item['kondisi_saat_dikembalikan'] ?? 'Baik',
                            statusColor: (item['kondisi_saat_dikembalikan'] == 'Rusak') ? Colors.red : Colors.green,
                            denda: item['denda'] != null ? 'Denda : Rp ${item['denda']}' : 'Tanpa Denda',
                            tglKembali: item['tanggal_kembali_asli'] ?? '-',
                            onDelete: () => _showDeleteDialog(item['kembali_id']),
                            onEdit: () => showDialog(context: context, builder: (context) => EditPengembalianDialog(data: item, onSave: _updatePengembalian)),
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
      bottomNavigationBar: AdminBottomNavbar(currentIndex: _currentIndex, onTap: _onNavTapped),
    );
  }
}

class PengembalianCard extends StatelessWidget {
  final String kode, nama, status, denda, tglKembali;
  final Color statusColor;
  final VoidCallback onDelete, onEdit;
  final Map<String, dynamic> fullData;

  const PengembalianCard({super.key, required this.kode, required this.nama, required this.status, required this.statusColor, required this.denda, required this.tglKembali, required this.onDelete, required this.onEdit, required this.fullData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF7A21).withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(kode, style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Unit dikembalikan", style: TextStyle(color: Colors.grey, fontSize: 12)), Text(nama, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))])),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Tgl kembali", style: TextStyle(color: Colors.grey, fontSize: 12)), Text(tglKembali, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(denda, style: TextStyle(color: denda.contains('Rp') ? Colors.red : Colors.black45, fontWeight: FontWeight.w600, fontSize: 13)),
              Row(
                children: [
                  _actionIcon(Icons.visibility, const Color(0xFFFF7A21), () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPengembalianPage(item: fullData)))),
                  const SizedBox(width: 6),
                  _actionIcon(Icons.edit_outlined, const Color(0xFFFF7A21), onEdit),
                  const SizedBox(width: 6),
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
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 20)));
  }
}

class EditPengembalianDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(dynamic id, Map<String, dynamic> updates) onSave;
  const EditPengembalianDialog({super.key, required this.data, required this.onSave});

  @override
  State<EditPengembalianDialog> createState() => _EditPengembalianDialogState();
}

class _EditPengembalianDialogState extends State<EditPengembalianDialog> {
  late TextEditingController _tglController, _kondisiController, _dendaController;

  @override
  void initState() {
    super.initState();
    _tglController = TextEditingController(text: widget.data['tanggal_kembali_asli'] ?? '');
    _kondisiController = TextEditingController(text: widget.data['kondisi_saat_dikembalikan'] ?? '');
    _dendaController = TextEditingController(text: widget.data['denda']?.toString() ?? '0');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(color: const Color(0xFFFFF7F2), borderRadius: BorderRadius.circular(40)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Edit pengembalian", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
              _buildField("Tgl kembali", _tglController),
              _buildField("Kondisi", _kondisiController),
              _buildField("Denda", _dendaController),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF7A21)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Batal", style: TextStyle(color: Color(0xFFFF7A21))))),
                  const SizedBox(width: 15),
                  Expanded(child: ElevatedButton(onPressed: () => widget.onSave(widget.data['kembali_id'], {'tanggal_kembali_asli': _tglController.text, 'kondisi_saat_dikembalikan': _kondisiController.text, 'denda': int.tryParse(_dendaController.text) ?? 0}), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A21), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Simpan", style: TextStyle(color: Colors.white)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(top: 12, bottom: 5), child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFF7A21).withOpacity(0.3))), child: TextField(controller: controller, decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12)))),
    ]);
  }
}