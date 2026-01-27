import 'package:flutter/material.dart';
import 'package:sipetir/widgets/header_custom.dart';

class DashboardPetugasPage extends StatelessWidget {
  const DashboardPetugasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6), // Background krem lembut
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
               HeaderCustom(
      title: 'Dashboard',
      subtitle: 'Petugas',
    ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // --- SEARCH BAR ---
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Username',
                      hintStyle: const TextStyle(color: Color(0xFFFFB385)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB385)),
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
                  const SizedBox(height: 20),

                  // --- STATISTIC CARDS (Total User & Alat) ---
                  Row(
                    children: [
                      _buildStatCard(Icons.people_outline, '180', 'TOTAL USER'),
                      const SizedBox(width: 15),
                      _buildStatCard(Icons.build_outlined, '18', 'TOTAL ALAT'),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- LIST PERMINTAAN ---
                  _buildRequestCard(
                    status: 'pending',
                    showActionButtons: true,
                  ),
                  _buildRequestCard(
                    status: 'Disetujui',
                    statusColor: const Color(0xFFFFDAB9),
                    textColor: const Color(0xFFFF7A21),
                  ),
                  _buildRequestCard(
                    status: 'Ditolak',
                    statusColor: const Color(0xFFFFC1C1),
                    textColor: Colors.red,
                    reason: 'Alasan : Alat sedang dalam perbaikan',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Box Statistik di atas
  Widget _buildStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB385)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF7A21), size: 35),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget untuk Kartu Persetujuan
  Widget _buildRequestCard({
    required String status,
    Color? statusColor,
    Color? textColor,
    bool showActionButtons = false,
    String? reason,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFFFDAB9),
                child: const Text('AF', style: TextStyle(color: Color(0xFFFF7A21))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Kun Fayakun', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('XII', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Text('22 Jan 2026', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDAB9).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Seragam APD K3', style: TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.w500)),
                Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF7A21)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          if (showActionButtons)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF7A21)),
                      shape: RoundedRectangleType(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Tolak', style: TextStyle(color: Color(0xFFFF7A21))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A21),
                      shape: RoundedRectangleType(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Setujui', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (reason != null) ...[
                  const SizedBox(height: 8),
                  Text(reason, style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                ]
              ],
            ),
        ],
      ),
    );
  }
}

RoundedRectangleType({required BorderRadius borderRadius}) {
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