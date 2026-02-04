import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sipetir/admin/alat/widgets%20alat/tambah_alat.page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/admin/alat/widgets%20alat/edit_alat_page.dart';
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
      final data = await supabase
          .from('Alat')
          .select('*, kategori(nama_kategori)')
          .order('updated_at', ascending: false);

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
              final nama = (alat['nama_barang'] ?? '').toString().toLowerCase();
              final kode = (alat['kode_alat'] ?? '').toString().toLowerCase();
              return nama.contains(keyword.toLowerCase()) ||
                  kode.contains(keyword.toLowerCase());
            }).toList();
    });
  }

  Future<void> _handleTambahAlat(Map dataDariDialog) async {
    setState(() => _isLoading = true);
    try {
      String? imageUrl;

      if (dataDariDialog['file_gambar'] != null) {
        final String fileName =
            'alat_${DateTime.now().millisecondsSinceEpoch}.png';

        await supabase.storage
            .from('GAMBAR_ALAT.')
            .uploadBinary(
              fileName,
              dataDariDialog['file_gambar'] as Uint8List,
              fileOptions: const FileOptions(contentType: 'image/png'),
            );

        imageUrl = supabase.storage.from('GAMBAR_ALAT.').getPublicUrl(fileName);
      }

      await supabase.from('Alat').insert({
        'nama_barang': dataDariDialog['nama'],
        'kode_alat': dataDariDialog['kode'],
        'kategori_id': dataDariDialog['kategori_id'],
        'gambar_url': imageUrl,
      });

      await _fetchAlat();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Alat Berhasil Ditambahkan!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Gagal Simpan: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal Simpan: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                      physics: const AlwaysScrollableScrollPhysics(),
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
                          _buildAddButton(),
                          const SizedBox(height: 25),
                          _buildListAlat(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);

          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PeminjamanPage()),
            );
          } else if (i == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PengembalianPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const TambahAlatPage(),
        ).then((value) {
          if (value != null && value is Map) _handleTambahAlat(value);
        });
      },
      icon: const Icon(Icons.add_circle, color: Colors.white),
      label: const Text("Tambah Alat Baru"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF58220),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildListAlat() {
    if (_foundAlat.isEmpty)
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text("Data tidak ditemukan"),
        ),
      );
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _foundAlat.length,
      itemBuilder: (_, i) {
        final item = _foundAlat[i];
        return ItemCard(
          item: item,
          supabase: supabase,
          fetchAlat: _fetchAlat,
          onEdit: () {
            showDialog(
              context: context,
              builder: (context) => EditAlatPage(data: item),
            ).then((v) {
              if (v == true) _fetchAlat();
            });
          },
        );
      },
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

// ================= ITEM CARD =================
class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final SupabaseClient supabase;
  final VoidCallback fetchAlat;
  final VoidCallback onEdit;

  const ItemCard({
    super.key,
    required this.item,
    required this.supabase,
    required this.fetchAlat,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final String title = item['nama_barang'] ?? '';
    final String itemCode = item['kode_alat'] ?? '';
    final String category =
        item['kategori']?['nama_kategori'] ?? 'Tanpa Kategori';
    final String? imagePath = item['gambar_url'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFFBB074), width: 1.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 85,
              height: 85,
              color: const Color(0xFFD9D9D9),
              child: imagePath != null && imagePath.isNotEmpty
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Kode : $itemCode",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF58220),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
                          () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Konfirmasi Hapus"),
                                  content: const Text(
                                    "Anda ingin menghapus alat ini?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Tidak"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFF58220,
                                        ),
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Iya"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              try {
                                await supabase.from('Alat').delete().match({
                                  'alat_id': item['alat_id'],
                                });
                                fetchAlat();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Alat berhasil dihapus!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Gagal menghapus: $e"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
