import 'package:flutter/material.dart';
import 'package:sipetir/widgets/header_custom.dart'; 
import 'package:sipetir/admin/widgets/bottom_navbar.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  // 1. Tambahkan variabel untuk menyimpan index navbar
  int _currentIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF2E8),
      body: Column(
        children: [
          // Header dengan tombol kembali
          Stack(
            children: [
              const HeaderCustom(
                title: 'Kategori',
                subtitle: '', 
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
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- Search Bar ---
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
                        hintStyle: TextStyle(color: Colors.orange, fontSize: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // --- Button Tambah Alat ---
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    label: const Text('Tambah Alat Baru', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF58220),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --- List Cards ---
                  const CategoryCard(
                    title: 'Alat Ukur Listrik',
                    subtitle: 'Tang Amper, Megger, Watt Meter',
                    count: '4 alat tersedia',
                  ),
                  const CategoryCard(
                    title: 'Peralatan Mekanik',
                    subtitle: 'Techometer, Dial Indicator, Kunci Torsi',
                    count: '4 alat tersedia',
                  ),
                  const CategoryCard(
                    title: 'Alat Analisis & Quality Check',
                    subtitle: 'Conductivity Meter, Water Quality Tester, pH Meter',
                    count: '4 alat tersedia',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // 2. Berikan argumen yang diminta oleh AdminBottomNavbar
      bottomNavigationBar: AdminBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Tambahkan logika navigasi di sini jika diperlukan
        },
      ),
    );
  }
}

// Widget CategoryCard tetap sama
class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String count;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                  onPressed: () {},
                  icon: const Icon(Icons.edit_note, size: 18),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF58220),
                    side: const BorderSide(color: Color(0xFFF58220)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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