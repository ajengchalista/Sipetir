import 'package:flutter/material.dart';
import 'package:sipetir/widgets/header_custom.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6), // Warna background krem
      body: Column(
        children: [
          Stack(
            children: [
              HeaderCustom(
      title: 'Manajemen Peminjaman',
    ),
            ],
          ),

          // Judul dan Fitur Pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Peminjaman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7A21),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari Nama Alat / kode alat',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFFFF7A21)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFFFFB385)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFB385)),
                      ),
                      child: const Icon(Icons.tune, color: Color(0xFFFF7A21)),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Daftar Kartu Peminjaman
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildBorrowCard(
                  id: '#pmjkla-001',
                  name: 'Brilian Restu',
                  kelas: 'xii',
                  tglPinjam: '22 Jan 2026',
                  tglKembali: '23 Jan 2026',
                  status: 'Dipinjam',
                  statusColor: const Color(0xFFFF7A21),
                ),
                _buildBorrowCard(
                  id: '#pmjkla-001',
                  name: 'Kun Fayakun',
                  kelas: 'xi',
                  tglPinjam: '22 Jan 2026',
                  tglKembali: '23 Jan 2026',
                  status: 'Terlambat',
                  statusColor: const Color(0xFFFF8A8A),
                ),
                _buildBorrowCard(
                  id: '#pmjkla-001',
                  name: 'Masyallah',
                  kelas: 'xii',
                  tglPinjam: '22 Jan 2026',
                  tglKembali: '22 Jan 2026',
                  status: 'Dipinjam',
                  statusColor: const Color(0xFFFF7A21),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowCard({
    required String id,
    required String name,
    required String kelas,
    required String tglPinjam,
    required String tglKembali,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id, style: const TextStyle(color: Color(0xFFFF7A21), fontSize: 12)),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(kelas, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('tgl pinjam', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      Text(tglPinjam, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('tgl kembali', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      Text(tglKembali, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(width: 40), // Spasi untuk ikon aksi
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.visibility, color: statusColor, size: 22),
                  const SizedBox(width: 10),
                  Icon(Icons.edit_note, color: statusColor, size: 22),
                  const SizedBox(width: 10),
                  const Icon(Icons.delete, color: Colors.redAccent, size: 22),
                ],
              )
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) { // Pastikan namanya getClip, bukan get saja
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(0, size.height, 40, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}