import 'package:flutter/material.dart';

class TabDisetujui extends StatelessWidget {
  const TabDisetujui({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3, 
      itemBuilder: (context, index) {
        return _buildCardDisetujui();
      },
    );
  }

  Widget _buildCardDisetujui() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: Column(
        children: [
          _buildUserHeader(),
          const SizedBox(height: 15),
          _buildItemInfo(),
          const SizedBox(height: 15),
          // Label Status Disetujui (Sesuai Gambar)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5D1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Disetujui',
                style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header User & Info Item (Sama dengan sebelumnya)
  Widget _buildUserHeader() {
    return Row(
      children: [
        Container(
          width: 45, height: 45,
          decoration: const BoxDecoration(color: Color(0xFFFFE5D1), shape: BoxShape.circle),
          child: const Center(child: Text('AF', style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold))),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kun Fayakun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('XII', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        const Text('22 Jan 2026', style: TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildItemInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFFFE5D1), borderRadius: BorderRadius.circular(15)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Seragam APD K3', style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)),
          Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFF7A21)),
        ],
      ),
    );
  }
}