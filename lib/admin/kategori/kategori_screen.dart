import 'package:flutter/material.dart';
import 'package:sipetir/admin/kategori/widget%20kategori/edit_kategori.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';
// Import file tambah kategori
import 'package:sipetir/admin/kategori/widget%20kategori/tambah_kategori_baru.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  int _currentIndex = 0;

  // 1. DATA LIST KATEGORI DIUBAH MENJADI STATIC
  // Agar data tidak reset saat pindah halaman (Navigator push/pop)
  static List<Map<String, String>> categories = [
    {
      'title': 'Alat Ukur Listrik',
      'subtitle': 'Tang Amper, Megger, Watt Meter',
      'count': '4 alat tersedia',
    },
    {
      'title': 'Peralatan Mekanik',
      'subtitle': 'Techometer, Dial Indicator, Kunci Torsi',
      'count': '4 alat tersedia',
    },
  ];

  // --- FUNGSI TAMBAH KATEGORI BARU ---
  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TambahKategoriBaru(
        onSave: (nama, keterangan) {
          setState(() {
            // Data dimasukkan ke list static sehingga tersimpan di memori
            categories.insert(0, {
              'title': nama,
              'subtitle': keterangan,
              'count': '0 alat tersedia',
            });
          });
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Tidak',
                          style: TextStyle(color: Color(0xFFF58220)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            categories.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF58220),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
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
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryForm(
        initialNama: categories[index]['title']!,
        initialKeterangan: categories[index]['subtitle']!,
        onSave: (newNama, newKeterangan) {
          setState(() {
            categories[index]['title'] = newNama;
            categories[index]['subtitle'] = newKeterangan;
          });
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
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
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
            child: SingleChildScrollView(
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
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.orange),
                        hintText: 'Cari Nama kategori / nama alat',
                        hintStyle: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // --- BUTTON TAMBAH KATEGORI ---
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context),
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    label: const Text('tambah kategori baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF58220),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // RENDER LIST
                  ...categories.asMap().entries.map((entry) {
                    int index = entry.key;
                    var item = entry.value;
                    return CategoryCard(
                      title: item['title']!,
                      subtitle: item['subtitle']!,
                      count: item['count']!,
                      onDelete: () => _showDeleteDialog(context, index),
                      onEdit: () => _showEditDialog(context, index),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBB074),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  count,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
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
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF58220),
                    side: const BorderSide(color: Color(0xFFF58220)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
