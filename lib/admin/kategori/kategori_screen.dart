import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';
import 'package:sipetir/admin/kategori/widget kategori/edit_kategori.dart';
import 'package:sipetir/admin/kategori/widget%20kategori/tambah_kategori_baru.dart';
import 'services/kategori_service.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  final KategoriService _kategoriService = KategoriService();

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> filteredCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future<void> _ambilData() async {
    setState(() => isLoading = true);
    try {
      final data = await supabase
          .from('kategori')
          .select()
          .order('nama_kategori');

      categories = List<Map<String, dynamic>>.from(data);
      filteredCategories = List.from(categories);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data: $e')),
        );
      }
    }
    setState(() => isLoading = false);
  }

  void _searchKategori(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories = List.from(categories);
      } else {
        filteredCategories = categories.where((item) {
          final nama = (item['nama_kategori'] ?? '').toString().toLowerCase();
          final ket = (item['keterangan'] ?? '').toString().toLowerCase();
          return nama.contains(query.toLowerCase()) ||
              ket.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => TambahKategoriBaru(onSuccess: _ambilData),
    );
  }

  // PERBAIKAN: Nama fungsi disamakan dan memanggil _ambilData()
  void _showEditDialog(Map<String, dynamic> kategori) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryForm(
        initialNama: kategori['nama_kategori'],
        initialKeterangan: kategori['keterangan'] ?? '',
        onSave: (namaBaru, keteranganBaru) async {
          // Ambil referensi messenger sebelum proses async dimulai
          final messenger = ScaffoldMessenger.of(this.context);
          
          try {
            await _kategoriService.updateKategori(
              id: kategori['kategori_id'], 
              nama: namaBaru,
              keterangan: keteranganBaru,
            );

            // Cek apakah widget masih aktif sebelum update UI
            if (!mounted) return;
            
            _ambilData(); 

            messenger.showSnackBar(
              const SnackBar(
                content: Text("Kategori berhasil diperbarui"), 
                backgroundColor: Colors.green
              ),
            );
          } catch (e) {
            if (!mounted) return;
            
            messenger.showSnackBar(
              SnackBar(
                content: Text("Gagal update: $e"), 
                backgroundColor: Colors.red
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> kategori) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: const Color(0xFFFEF2E8),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Anda yakin ingin menghapusnya?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Tidak',
                        style: TextStyle(color: Color(0xFFF58220)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // PERBAIKAN: Menggunakan 'kategori_id' sesuai skema SQL
                          await supabase
                              .from('kategori')
                              .delete()
                              .eq('kategori_id', kategori['kategori_id']);

                          if (mounted) Navigator.pop(context);
                          _ambilData();
                        } on PostgrestException catch (e) {
                          String errorMsg = "Gagal hapus: ${e.message}";
                          // Cek jika ada data di tabel Alat yang memakai kategori ini
                          if (e.code == '23503') {
                            errorMsg = "Kategori tidak bisa dihapus karena masih digunakan oleh beberapa alat.";
                          }
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMsg),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Terjadi kesalahan: $e")),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF58220),
                      ),
                      child: const Text(
                        'Iya',
                        style: TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF2E8),
      body: Column(
        children: [
          Stack(
            children: [
              const HeaderCustom(title: 'Kategori', subtitle: ''),
              Positioned(
                top: 50,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 50,
                right: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFF58220)))
                : RefreshIndicator(
                    onRefresh: _ambilData,
                    color: const Color(0xFFF58220),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _searchKategori,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.search, color: Colors.orange),
                                hintText: 'Cari Nama kategori / nama alat',
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: _showAddDialog,
                            icon: const Icon(Icons.add_circle, color: Colors.white),
                            label: const Text(
                              'tambah kategori baru',
                              style: TextStyle(color: Color(0xFFFFF1CC)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF58220),
                              minimumSize: const Size(double.infinity, 55),
                            ),
                          ),
                          const SizedBox(height: 25),
                          if (filteredCategories.isEmpty)
                            const Text('Tidak ada kategori tersedia')
                          else
                            ...filteredCategories.map((item) {
                              return CategoryCard(
                                title: item['nama_kategori'] ?? '-',
                                subtitle: item['keterangan'] ?? '-',
                                count: 'Alat Aktif',
                                onEdit: () => _showEditDialog(item),
                                onDelete: () => _showDeleteDialog(item),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String count;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBB074),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(count, style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}