import 'package:flutter/material.dart';
import 'package:sipetir/widgets/header_custom.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Column(
        children: [
          // HEADER
          const HeaderCustom(
            title: 'Manajemen Peminjaman',
          ),

          const SizedBox(height: 20),

          // SEARCH & TITLE
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
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
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
                      ),
                      child: const Icon(Icons.tune, color: Color(0xFFFF7A21)),
                    )
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // LIST CARD
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildBorrowCard(
                  id: '#pmjkla-001',
                  name: 'Brilian Restu',
                  kelas: 'XII',
                  tglPinjam: '22 Jan 2026',
                  tglKembali: '23 Jan 2026',
                  status: 'Dipinjam',
                  statusColor: Color(0xFFFF7A21),
                ),
                _buildBorrowCard(
                  id: '#pmjkla-002',
                  name: 'Kun Fayakun',
                  kelas: 'XI',
                  tglPinjam: '22 Jan 2026',
                  tglKembali: '23 Jan 2026',
                  status: 'Terlambat',
                  statusColor: Color(0xFFFF8A8A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBorrowCard({
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
              Text(kelas, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pinjam: $tglPinjam'),
                  Text('Kembali: $tglKembali'),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          )
        ],
      ),
    );
  }
}
