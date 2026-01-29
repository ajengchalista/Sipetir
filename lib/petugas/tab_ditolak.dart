import 'package:flutter/material.dart';

class TabDitolak extends StatelessWidget {
  const TabDitolak({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 2, 
      itemBuilder: (context, index) {
        return _buildCardDitolak();
      },
    );
  }

  Widget _buildCardDitolak() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(),
          const SizedBox(height: 15),
          _buildItemInfo(),
          const SizedBox(height: 15),
          // Label Status Ditolak
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD6D6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Ditolak',
                style: TextStyle(color: Color(0xFFF44336), fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Teks Alasan (Sesuai Gambar)
          const Text(
            'Alasan : Alat sedang dalam perbaikan',
            style: TextStyle(color: Color(0xFFF44336), fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Header & Info Item (Sama dengan Disetujui)
  Widget _buildUserHeader() { /* Copy paste dari file atas */ return Container(); }
  Widget _buildItemInfo() { /* Copy paste dari file atas */ return Container(); }
}