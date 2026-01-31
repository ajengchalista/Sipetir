import 'package:flutter/material.dart';
import 'package:sipetir/admin/alat/tambah_alat_page.dart';
import 'package:sipetir/admin/alat/widgets alat/edit_alat_page.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';
import 'package:sipetir/widgets/header_custom.dart';

class ManajemenAlatPage extends StatefulWidget {
  const ManajemenAlatPage({super.key});

  @override
  State<ManajemenAlatPage> createState() => _ManajemenAlatPageState();
}

class _ManajemenAlatPageState extends State<ManajemenAlatPage> {
  // Data dummy utama
  final List<Map<String, String>> _allAlat = [
    {
      'title': 'Sarung Tangan Listrik',
      'itemCode': 'AL-011',
      'category': 'Keselamatan Kerja (K3)',
    },
    {
      'title': 'Kunci Torsi',
      'itemCode': 'AL-006',
      'category': 'Peralatan Mekanik',
    },
    {
      'title': 'pH Meter',
      'itemCode': 'AL-009',
      'category': 'Alat Analisis & Quality check',
    },
  ];

  List<Map<String, String>> _foundAlat = [];
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _foundAlat = _allAlat;
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundAlat = keyword.isEmpty
          ? _allAlat
          : _allAlat
                .where(
                  (alat) =>
                      alat['title']!.toLowerCase().contains(
                        keyword.toLowerCase(),
                      ) ||
                      alat['itemCode']!.toLowerCase().contains(
                        keyword.toLowerCase(),
                      ),
                )
                .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFE5),
      body: Column(
        children: [
          Stack(
            children: [
              const HeaderCustom(title: 'daftar alat', subtitle: 'Admin'),
              Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Alat',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'ALAT TERSEDIA',
                          value: _foundAlat.length.toString(),
                          icon: Icons.check_circle_outline,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: StatCard(
                          label: 'ALAT DIPINJAM',
                          value: '8',
                          icon: Icons.access_time,
                          iconColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: _runFilter,
                          decoration: InputDecoration(
                            hintText: 'Cari Nama Alat / Kode',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.orange,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFFF5ED),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.orange.withOpacity(0.4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5ED),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.4),
                          ),
                        ),
                        child: const Icon(Icons.tune, color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0822D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const TambahAlatPage(),
                        );
                      },
                      icon: const Icon(Icons.add_circle, color: Colors.white),
                      label: const Text(
                        'Tambah Alat Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _foundAlat.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _foundAlat.length,
                          itemBuilder: (_, i) => ItemCard(
                            title: _foundAlat[i]['title']!,
                            itemCode: _foundAlat[i]['itemCode']!,
                            category: _foundAlat[i]['category']!,
                            onEdit: () async {
                              // Menunggu hasil data dari EditAlatPage
                              final result =
                                  await showModalBottomSheet<
                                    Map<String, String>
                                  >(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        EditAlatPage(data: _foundAlat[i]),
                                  );

                              // Jika simpan ditekan dan data tidak kosong
                              if (result != null) {
                                setState(() {
                                  int index = _allAlat.indexWhere(
                                    (element) =>
                                        element['itemCode'] ==
                                        _foundAlat[i]['itemCode'],
                                  );

                                  if (index != -1) {
                                    _allAlat[index] = result;
                                    _foundAlat = List.from(_allAlat);
                                  }
                                });

                                // Tampilkan SnackBar Berhasil
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Data berhasil diperbarui'),
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      255,
                                      103,
                                      8,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            onDelete: () {
                              setState(() {
                                _allAlat.removeWhere(
                                  (element) =>
                                      element['itemCode'] ==
                                      _foundAlat[i]['itemCode'],
                                );
                                _foundAlat = List.from(_allAlat);
                              });
                            },
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Alat tidak ditemukan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                ],
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
}

// --- REUSABLE WIDGETS ---

class StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 35),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String title, itemCode, category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'Kode Alat : $itemCode',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0822D),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  _iconBtn(
                    Icons.edit_calendar_outlined,
                    const Color(0xFFFFEBD8),
                    Colors.orange,
                    onEdit,
                  ),
                  const SizedBox(width: 8),
                  _iconBtn(
                    Icons.delete_outline,
                    const Color(0xFFFFE5E5),
                    Colors.red,
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

  Widget _iconBtn(IconData icon, Color bg, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
