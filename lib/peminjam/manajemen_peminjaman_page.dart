import 'package:flutter/material.dart';

class PeminjamanContentView extends StatelessWidget {
  const PeminjamanContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul section tetap ada di sini agar mirip gambar
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Text(
            'Informasi Peminjaman',
            style: TextStyle(
              color: Color(0xFFF47521),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Daftar Kartu
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              // Status: Menunggu (Orange)
              _buildCard(
                "Conductivity Meter",
                "Menunggu Persetujuan",
                const Color(0xFFF47521),
              ),
              // Status: Dikembalikan (Abu-abu)
              _buildCard("Tang Amper", "Dikembalikan", const Color(0xFFCCCCCC)),
              // Status: Ditolak (Pink/Merah Muda)
              _buildCard("Tang Amper", "Ditolak", const Color(0xFFFF9999)),
            ],
          ),
        ),
      ],
    );
  }

  // Helper untuk membangun Kartu (Tetap sama)
  Widget _buildCard(String title, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDB98E)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Kode Alat :  AL-006',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 15),
              _buildRow(
                Icons.calendar_month_outlined,
                "Tgl Pinjam : ",
                "26 Jan 2026",
                Colors.orange,
              ),
              const SizedBox(height: 5),
              _buildRow(
                Icons.access_time,
                "Tgl Kembali : ",
                "26 Jan 2026",
                Colors.red,
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String date, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(
          date,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: label.contains("Kembali") ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}
