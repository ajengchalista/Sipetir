import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/admin/alat/alat_page.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/admin/pengembalian/widgets/detail_pengembalian.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  int _currentIndex = 3;
  late final Stream<List<Map<String, dynamic>>> _pengembalianStream;

  @override
  void initState() {
    super.initState();
    _pengembalianStream = supabase
        .from('pengembalian')
        .stream(primaryKey: ['kembali_id'])
        .order('tanggal_kembali_asli');
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
      case 3:
        break;
    }
  }

  void _showEditDialog(Map<String, dynamic> itemData) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return EditPengembalianDialog(data: itemData);
      },
    );
  }

  Future<void> _deleteData(dynamic id) async {
    try {
      await supabase.from('pengembalian').delete().eq('kembali_id', id);
      if (mounted) {
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

  void _showDeleteDialog(dynamic id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Tidak",
                        style: TextStyle(
                          color: Color(0xFFFF7A21),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Iya",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
        children: [
          Stack(
            children: [
              const HeaderCustom(title: 'Pengembalian', subtitle: 'Admin'),
              Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilPage()),
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
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
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Pengembalian',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFFFF7A21),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _pengembalianStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF7A21),
                          ),
                        );
                      final data = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return PengembalianCard(
                            fullData: item,
                            kode: item['pinjam_id']?.toString() ?? '-',
                            nama: item['kondisi_saat_dikembalikan'] ?? 'Baik',
                            status: item['kondisi_saat_dikembalikan'] ?? 'Baik',
                            statusColor:
                                (item['kondisi_saat_dikembalikan'] == 'Rusak')
                                ? Colors.red
                                : Colors.green,
                            denda: item['denda'] != null
                                ? 'Denda : ${item['denda']}'
                                : 'Tanpa Denda',
                            tglKembali: item['tanggal_kembali_asli'] ?? '-',
                            onDelete: () =>
                                _showDeleteDialog(item['kembali_id']),
                            onEdit: () => _showEditDialog(item),
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
  final VoidCallback onEdit;
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
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF7A21).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kode,
                style: const TextStyle(
                  color: Color(0xFFFF7A21),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Unit dikembalikan",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    nama,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tgl kembali",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    tglKembali,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                denda,
                style: TextStyle(
                  color: denda != 'Tanpa Denda' ? Colors.red : Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  _actionIcon(
                    Icons.visibility,
                    const Color(0xFFFF7A21),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPengembalianPage(item: fullData),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  _actionIcon(
                    Icons.edit_outlined,
                    const Color(0xFFFF7A21),
                    onEdit,
                  ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

// --- WIDGET DIALOG EDIT ---
class EditPengembalianDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditPengembalianDialog({super.key, required this.data});

  @override
  State<EditPengembalianDialog> createState() => _EditPengembalianDialogState();
}

class _EditPengembalianDialogState extends State<EditPengembalianDialog> {
  final Color accentOrange = const Color(0xFFFF7A21);
  final Color bgColor = const Color(0xFFFFF7F2);

  late TextEditingController _kategoriController;
  late TextEditingController _tglController;
  late TextEditingController _unitController;
  late TextEditingController _dendaController;
  String? _selectedKondisi;

  @override
  void initState() {
    super.initState();
    _kategoriController = TextEditingController(text: "Sarung Tangan Listrik");
    _tglController = TextEditingController(
      text: widget.data['tanggal_kembali_asli'] ?? '',
    );
    _unitController = TextEditingController(
      text: widget.data['pinjam_id']?.toString() ?? '1',
    );
    _dendaController = TextEditingController(
      text: widget.data['denda']?.toString() ?? 'Tanpa Denda',
    );
    _selectedKondisi = (widget.data['kondisi_saat_dikembalikan'] == "Rusak")
        ? "Rusak"
        : "Baik";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit pengembalian",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: accentOrange,
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel("Nama Kategori"),
              _buildTextField(_kategoriController),
              _buildLabel("Tgl kembali"),
              _buildTextField(_tglController),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("unit"),
                        _buildTextField(_unitController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_buildLabel("Kondisi"), _buildDropdownField()],
                    ),
                  ),
                ],
              ),
              _buildLabel("Denda"),
              _buildTextField(_dendaController),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: accentOrange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Batal",
                        style: TextStyle(
                          color: accentOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentOrange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 5, top: 15),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildTextField(TextEditingController controller) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: accentOrange.withOpacity(0.5)),
    ),
    child: TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    ),
  );

  Widget _buildDropdownField() => LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: accentOrange.withOpacity(0.5)),
        ),
        child: PopupMenuButton<String>(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            maxWidth: constraints.maxWidth,
          ),
          offset: const Offset(0, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onSelected: (v) => setState(() => _selectedKondisi = v),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedKondisi ?? "Baik",
                  style: const TextStyle(fontSize: 14),
                ),
                Icon(Icons.arrow_drop_down, color: accentOrange),
              ],
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "Baik",
              child: Row(
                children: [
                  Icon(
                    _selectedKondisi == "Baik"
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: accentOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text("Baik"),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: "Rusak",
              child: Row(
                children: [
                  Icon(
                    _selectedKondisi == "Rusak"
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: accentOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text("Rusak"),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
