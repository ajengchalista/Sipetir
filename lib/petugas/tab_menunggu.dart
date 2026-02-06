import 'package:flutter/material.dart';

class TabMenunggu extends StatelessWidget {
  const TabMenunggu({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildCardPending();
      },
    );
  }

  Widget _buildCardPending() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: Column(
        children: [
          // Row Profil & Nama (AF - Kun Fayakun)
          Row(
            children: [
              CircleAvatar(backgroundColor: Color(0xFFFFE5D1), child: Text('AF', style: TextStyle(color: Color(0xFFFF7A21)))),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kun Fayakun', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('XII', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Text('22 Jan 2026', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          SizedBox(height: 15),
          // Info Item (Seragam APD K3)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(color: Color(0xFFFFE5D1), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Seragam APD K3', style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF7A21)),
              ],
            ),
          ),
          SizedBox(height: 15),
          // Tombol Aksi (Khusus Tab Menunggu)
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () {}, child: Text('Tolak'))),
              SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () {}, child: Text('Setujui'))),
            ],
          )
        ],
      ),
    );
  }
}