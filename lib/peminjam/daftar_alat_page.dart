import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DaftarAlatPage extends StatefulWidget {
  // Change this to match the parameter name you are using in Dashboard
  final Function(Map<String, dynamic>) onTambahKeranjang; 
  
  const DaftarAlatPage({super.key, required this.onTambahKeranjang});

  @override
  State<DaftarAlatPage> createState() => _DaftarAlatPageState();
}

class _DaftarAlatPageState extends State<DaftarAlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  String _searchQuery = "";

  // Query stream dengan join ke tabel kategori
  late final Stream<List<Map<String, dynamic>>> _alatStream;

  @override
  void initState() {
    super.initState();
    _alatStream = supabase
        .from('Alat')
        .stream(primaryKey: ['alat_id'])
        .order('nama_barang');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header & Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daftar Alat', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
              const SizedBox(height: 15),
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Cari Nama atau Kode Alat...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB385)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFFFFB385)),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _alatStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Tidak ada alat tersedia"));
              }

              // Filter Search
              final items = snapshot.data!.where((alat) {
                final nama = alat['nama_barang'].toString().toLowerCase();
                final kode = alat['kode_alat'].toString().toLowerCase();
                return nama.contains(_searchQuery) || kode.contains(_searchQuery);
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final alat = items[index];
                  return _buildAlatCard(alat);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAlatCard(Map<String, dynamic> alat) {
  bool isTersedia = alat['status_barang'] == 'tersedia';

  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFFFB385).withOpacity(0.5)),
    ),
    // Bungkus isi Container dengan GestureDetector jika ingin satu kartu bisa diklik
    child: GestureDetector(
      onTap: isTersedia ? () => widget.onTambahKeranjang(alat) : null,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row untuk Kode Alat dan Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  alat['kode_alat'] ?? '-', 
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isTersedia ? const Color(0xFFD1FAE5) : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isTersedia ? 'Tersedia' : 'Dipinjam',
                    style: TextStyle(
                      color: isTersedia ? const Color(0xFF10B981) : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Nama Barang
            Text(
              alat['nama_barang'] ?? 'Tanpa Nama',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            // Row untuk Kategori dan Tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kategori: Alat Teknik",
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
                ElevatedButton(
                  // Tombol otomatis mati (greyed out) jika status tidak tersedia
                  onPressed: isTersedia ? () => widget.onTambahKeranjang(alat) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE5D1),
                    foregroundColor: const Color(0xFFFF7A21),
                    disabledBackgroundColor: Colors.grey.shade200,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Pinjam'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}