import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanContentView extends StatelessWidget {
  const PeminjamanContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: supabase.from('peminjaman').select('''
              *,
              detail_peminjaman (
                Alat (nama_barang, kode_alat)
              )
            ''').eq('user_id', userId).order('tanggal_pinjam', ascending: false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFF47521)));
              }
              if (snapshot.hasError) {
                return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Belum ada riwayat peminjaman"));
              }

              final listPeminjaman = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: listPeminjaman.length,
                itemBuilder: (context, index) {
                  final item = listPeminjaman[index];
                  final details = item['detail_peminjaman'] as List;
                  
                  String namaBarang = details.isNotEmpty 
                      ? details[0]['Alat']['nama_barang'] 
                      : "Alat Tidak Diketahui";
                  String kodeAlat = details.isNotEmpty 
                      ? details[0]['Alat']['kode_alat'] 
                      : "N/A";

                  // AMBIL DATA SISWA
                  String namaSiswa = item['nama_siswa'] ?? "Siswa";
                  String kelas = item['tingkatan_kelas'] ?? "-";
                  
                  String statusText = item['status'].toString();
                  Color statusColor = const Color(0xFFF47521); 
                  
                  if (statusText == 'dikembalikan') statusColor = const Color(0xFFCCCCCC);
                  if (statusText == 'ditolak') statusColor = const Color(0xFFFF9999);

                  return _buildCard(
                    "$namaBarang ($namaSiswa - $kelas)", // Gabungkan di Title
                    kodeAlat,
                    statusText.toUpperCase(),
                    statusColor,
                    item['tanggal_pinjam'],
                    item['tanggal_kembali'],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String kode, String status, Color statusColor, String tglP, String tglK) {
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Kode Alat : $kode',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 15),
              _buildRow(Icons.calendar_month_outlined, "Tgl Pinjam : ", tglP, Colors.orange),
              const SizedBox(height: 5),
              _buildRow(Icons.access_time, "Tgl Kembali : ", tglK, Colors.red),
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