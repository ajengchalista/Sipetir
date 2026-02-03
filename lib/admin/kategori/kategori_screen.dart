import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sipetir/admin/kategori/services/kategori_service.dart';
import 'package:sipetir/admin/kategori/widget kategori/edit_kategori.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';
import 'package:sipetir/admin/kategori/widget%20kategori/tambah_kategori_baru.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Variabel untuk menampung data dari Supabase
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> filteredCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _ambilData(); // Ambil data saat halaman pertama kali dibuka
  }

  // Fungsi untuk mengambil data dari Supabase
  Future<void> _ambilData() async {
    setState(() => isLoading = true);
    try {
      final data = await Supabase.instance.client
          .from('kategori')
          .select()
          .order('nama_kategori', ascending: true);

      setState(() {
        categories = List<Map<String, dynamic>>.from(data);
        filteredCategories = categories;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data: $e')),
        );
      }
    }
  }

  void _searchKategori(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories = List.from(categories);
      } else {
        filteredCategories = categories.where((item) {
          final title = (item['nama_kategori'] ?? '').toString().toLowerCase();
          final subtitle = (item['keterangan'] ?? '').toString().toLowerCase();
          final input = query.toLowerCase();
          return title.contains(input) || subtitle.contains(input);
        }).toList();
      }
    });
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TambahKategoriBaru(
        onSuccess: () {
          _ambilData(); // Refresh data otomatis setelah sukses tambah
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          backgroundColor: const Color(0xFFFEF2E8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Anda yakin ingin menghapusnya?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF58220)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('Tidak', style: TextStyle(color: Color(0xFFF58220))),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Tambahkan fungsi hapus Supabase di sini jika perlu
                          // await Supabase.instance.client.from('kategori').delete().match({'id': categories[index]['id']});
                          setState(() {
                            categories.removeAt(index);
                            filteredCategories = List.from(categories);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF58220),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('Iya', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryForm(
        initialNama: filteredCategories[index]['nama_kategori'] ?? '',
        initialKeterangan: filteredCategories[index]['keterangan'] ?? '',
        onSave: (newNama, newKeterangan) {
          // Logika update UI (idealnya panggil update ke Supabase juga)
          _ambilData(); 
        },
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
                  icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 35),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilPage()));
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFF58220)))
              : SingleChildScrollView(
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
                            hintStyle: TextStyle(color: Colors.orange, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () => _showAddDialog(context),
                        icon: const Icon(Icons.add_circle, color: Colors.white),
                        label: const Text(
                          'tambah kategori baru',
                          style: TextStyle(color: Color(0xFFFFF1CC)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF58220),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      if (filteredCategories.isEmpty)
                        const Text('Tidak ada kategori tersedia')
                      else
                        ...filteredCategories.asMap().entries.map((entry) {
                          final item = entry.value;
                          final originalIndex = categories.indexOf(item);
                          return CategoryCard(
                            title: item['nama_kategori'] ?? 'Tanpa Nama',
                            subtitle: item['keterangan'] ?? '-',
                            count: 'Alat Aktif', // Placeholder
                            onDelete: () => _showDeleteDialog(context, originalIndex),
                            onEdit: () => _showEditDialog(context, originalIndex),
                          );
                        }).toList(),
                    ],
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
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
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
                  icon: const Icon(Icons.edit_note, size: 18),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
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