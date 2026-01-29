import 'package:flutter/material.dart';
import 'package:sipetir/admin/alat/alat_page.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/widgets/bottom_navbar.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final Color orange = const Color(0xFFF37021);
  final Color bg = const Color(0xFFFFF2E9);

  int _currentIndex = 3;

  void _onNavTapped(int index) {
    if (_currentIndex == index) return;
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
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: orange,
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pengembalian',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.account_circle_outlined, color: Colors.white, size: 35),
          )
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: orange.withOpacity(0.3)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Pengembalian',
                  hintStyle: TextStyle(color: orange.withOpacity(.6)),
                  prefixIcon: Icon(Icons.search, color: orange),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const PengembalianCard(
              kode: '#AL-001',
              nama: 'Sarung Tangan Listrik',
              status: 'Baik',
              statusColor: Colors.green,
              denda: 'Tanpa Denda',
              tglKembali: '22 Jan 2026',
            ),
            const PengembalianCard(
              kode: '#AL-002',
              nama: 'Megger (Insulation Tester)',
              status: 'Rusak',
              statusColor: Colors.red,
              denda: 'Denda : 35.000',
              tglKembali: '22 Jan 2026',
            ),
            const PengembalianCard(
              kode: '#AL-009',
              nama: 'pH Meter',
              status: 'Baik',
              statusColor: Colors.green,
              denda: 'Tanpa Denda',
              tglKembali: '22 Jan 2026',
            ),
          ],
        ),
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

  const PengembalianCard({
    super.key,
    required this.kode,
    required this.nama,
    required this.status,
    required this.statusColor,
    required this.denda,
    required this.tglKembali,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDE2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF37021).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Kode & Badge Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(kode, style: const TextStyle(color: Color(0xFFF37021), fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 12),
          
          // Body: Nama Unit & Tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Unit dikembalikan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tgl kembali", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(tglKembali, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Footer: Denda & CRUD Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(denda, 
                style: TextStyle(
                  color: denda.contains('Denda') ? Colors.red : Colors.black45, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 13
                )
              ),
              Row(
                children: [
                  _actionIcon(Icons.visibility, const Color(0xFFF37021)),
                  const SizedBox(width: 8),
                  _actionIcon(Icons.edit_outlined, const Color(0xFFF37021)),
                  const SizedBox(width: 8),
                  _actionIcon(Icons.delete_outline, Colors.red),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}