import 'package:flutter/material.dart';
import 'package:sipetir/theme/app_colors.dart';
import 'package:sipetir/admin/pengembalian/widgets/detail_pengembalian.dart';

class DetailPengembalianPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailPengembalianPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Color statusColor = (item['kondisi_saat_dikembalikan'] == 'Rusak')
        ? Colors.red
        : Colors.green;

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        title: const Text(
          'Detail Pengembalian',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryOrange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.assignment_turned_in,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Status Kondisi",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "${item['kondisi_saat_dikembalikan'] ?? 'Baik'}",
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            _sectionTitle("Informasi Peminjaman"),
            _buildInfoCard([
              _infoRow("ID Kembali", "#${item['kembali_id']}"),
              _infoRow("ID Pinjam", "#${item['pinjam_id']}"),
              _infoRow("Tanggal Kembali", "${item['tanggal_kembali_asli']}"),
            ]),

            const SizedBox(height: 20),

            _sectionTitle("Rincian Alat & Denda"),
            _buildInfoCard([
              _infoRow("Nama Alat", "Unit Alat Lab", isBold: true),
              _infoRow(
                "Denda",
                "Rp ${item['denda'] ?? '0'}",
                textColor: (item['denda'] != null && item['denda'] != "0")
                    ? Colors.red
                    : Colors.green,
              ),
              const Divider(height: 30),
              const Text(
                "Catatan Admin:",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['keterangan'] ?? "Tidak ada catatan tambahan.",
                style: const TextStyle(height: 1.5, color: Colors.black87),
              ),
            ]),

            const SizedBox(height: 40),

            // Tombol Kembali
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "KEMBALI KE DAFTAR",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
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
        children: children,
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    Color? textColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: textColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
