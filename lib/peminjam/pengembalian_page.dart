import 'package:flutter/material.dart';

class PengembalianPage extends StatelessWidget {
  const PengembalianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pengembalian',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7A21),
            ),
          ),
          const SizedBox(height: 20),
          // Card 1: Status Dipinjam
          _buildReturnCard(
            title: 'Conductivity Meter',
            code: 'AL-006',
            borrowDate: '26 Jan 2026',
            returnDate: '26 Jan 2026',
            status: 'Dipinjam',
            statusColor: const Color(0xFFFF7A21),
            statusBg: Colors.transparent,
          ),
          const SizedBox(height: 20),
          // Card 2: Status Terlambat
          _buildReturnCard(
            title: 'Conductivity Meter',
            code: 'AL-006',
            borrowDate: '26 Jan 2026',
            returnDate: '26 Jan 2026',
            status: 'Terlambat',
            statusColor: Colors.red,
            statusBg: const Color(0xFFFFC1C1),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnCard({
    required String title,
    required String code,
    required String borrowDate,
    required String returnDate,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors
            .white, // PERUBAHAN: Sekarang menggunakan warna putih agar sama dengan kartu peminjaman
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.05,
            ), // Shadow dibuat lebih halus sesuai UI dashboard
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 4),
                  Text(
                    'Kode Alat :  $code',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDateRow(
            Icons.calendar_today_outlined,
            'Tgl Pinjam : ',
            borrowDate,
            Colors.black,
          ),
          const SizedBox(height: 5),
          _buildDateRow(
            Icons.access_time_filled,
            'Tgl Kembali : ',
            returnDate,
            Colors.red,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A21),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Ajukan Pengembalian',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(
    IconData icon,
    String label,
    String date,
    Color dateColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFFF7A21)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          date,
          style: TextStyle(color: dateColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
