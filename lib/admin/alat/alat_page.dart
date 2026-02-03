import 'package:flutter/material.dart';
import 'package:sipetir/admin/alat/widgets%20alat/tambah_alat.page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/admin/alat/widgets%20alat/edit_alat_page.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/pengembalian/pengembalian_page.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/admin/halaman%20profil/profil_page.dart';
import 'package:sipetir/widgets/header_custom.dart';

class ManajemenAlatPage extends StatefulWidget {
  const ManajemenAlatPage({super.key});

  @override
  State<ManajemenAlatPage> createState() => _ManajemenAlatPageState();
}

class _ManajemenAlatPageState extends State<ManajemenAlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _allAlat = [];
  List<Map<String, dynamic>> _foundAlat = [];
  int _currentIndex = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlat();
  }

  Future<void> _fetchAlat() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      // Mengambil data alat beserta nama_kategori dari tabel kategori
      final data = await supabase
          .from('Alat')
          .select('*, kategori(nama_kategori)');

      if (mounted) {
        setState(() {
          _allAlat = List<Map<String, dynamic>>.from(data);
          _foundAlat = _allAlat;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetch: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundAlat = keyword.isEmpty
          ? List.from(_allAlat)
          : _allAlat.where((alat) {
              final nama = alat['nama_barang'].toString().toLowerCase();
              final kode = alat['kode_alat'].toString().toLowerCase();
              return nama.contains(keyword.toLowerCase()) ||
                  kode.contains(keyword.toLowerCase());
            }).toList();
    });
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
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PeminjamanPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PengembalianPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF2E8),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF58220)),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchAlat,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Daftar Alat",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildStats(),
                          const SizedBox(height: 20),
                          _buildSearchBox(),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) =>
                                    const TambahAlatPage(),
                              ).then((value) {
                                if (value == true) _fetchAlat();
                              });
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: const Text("Tambah Alat Baru"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF58220),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          _foundAlat.isEmpty
                              ? const Center(child: Text("Tidak ada data alat"))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _foundAlat.length,
                                  itemBuilder: (_, i) {
                                    final item = _foundAlat[i];

                                    // PERBAIKAN: Ekstrak String kategori dari Map agar tidak TypeError
                                    String categoryName = 'Tanpa Kategori';
                                    if (item['kategori'] != null &&
                                        item['kategori'] is Map) {
                                      categoryName =
                                          item['kategori']['nama_kategori'] ??
                                          'Tanpa Kategori';
                                    }

                                    return ItemCard(
                                      title: item['nama_barang'] ?? '',
                                      itemCode: item['kode_alat'] ?? '',
                                      category: categoryName,
                                      onEdit: () {
                                        showDialog(
                                          context: context,
                                          barrierColor: Colors.black54,
                                          builder: (context) =>
                                              EditAlatPage(data: item),
                                        ).then((value) {
                                          if (value == true) _fetchAlat();
                                        });
                                      },
                                      onDelete: () async {
                                        await supabase
                                            .from('Alat')
                                            .delete()
                                            .match({
                                              'alat_id': item['alat_id'],
                                            });
                                        _fetchAlat();
                                      },
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
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

  Widget _buildHeader() {
    return Stack(
      children: [
        const HeaderCustom(title: 'Manajemen Alat', subtitle: ''),
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
        Positioned(
          top: 50,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatCard(
          "${_allAlat.length}",
          "TOTAL ALAT",
          Icons.inventory_2_outlined,
          Colors.blue,
        ),
        const SizedBox(width: 15),
        _buildStatCard("8", "ALAT DIPINJAM", Icons.access_time, Colors.orange),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFFBB074)),
            ),
            child: TextField(
              onChanged: _runFilter,
              decoration: const InputDecoration(
                hintText: 'Cari Nama Alat / kode alat',
                prefixIcon: Icon(Icons.search, color: Color(0xFFF58220)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFBB074)),
          ),
          child: const Icon(Icons.tune, color: Color(0xFFF58220)),
        ),
      ],
    );
  }

  // PERBAIKAN SINTAKSIS PENUTUP (Bracket & Parenthesis)
  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFBB074)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(width: 10),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String title, itemCode, category;
  final VoidCallback onEdit, onDelete;

  const ItemCard({
    super.key,
    required this.title,
    required this.itemCode,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFBB074), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            "Kode Alat : $itemCode",
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF58220),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                children: [
                  _actionButton(
                    Icons.edit_note,
                    const Color(0xFFFBB074),
                    onEdit,
                  ),
                  const SizedBox(width: 8),
                  _actionButton(
                    Icons.delete_outline,
                    const Color(0xFFF47171),
                    onDelete,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
