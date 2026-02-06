import 'package:flutter/material.dart';
import 'package:sipetir/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DaftarAlatPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onTambahKeranjang;

  const DaftarAlatPage({super.key, required this.onTambahKeranjang});

  @override
  State<DaftarAlatPage> createState() => _DaftarAlatPageState();
}

class _DaftarAlatPageState extends State<DaftarAlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> _alatStream;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _alatStream = supabase
        .from('Alat')
        .stream(primaryKey: ['alat_id'])
        .order('nama_barang', ascending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background krem pucat agar kartu putih terlihat menyala
      backgroundColor: const Color(0xFFFDF1E9), 
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Alat',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE67E22), // Warna Oranye pekat
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    // Kotak Pencarian
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFE67E22).withOpacity(0.4)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cari Nama Alat / kode alat',
                            hintStyle: TextStyle(color: Colors.orange.withOpacity(0.4), fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFFE67E22)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Tombol Filter
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE67E22).withOpacity(0.4)),
                      ),
                      child: const Icon(Icons.tune, color: Color(0xFFE67E22)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. LIST KARTU ALAT
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _alatStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFE67E22)));
                }
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada alat tersedia."));
                }

                final dataAlat = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: dataAlat.length,
                  itemBuilder: (context, index) => _buildAlatCard(dataAlat[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlatCard(Map<String, dynamic> item) {
    bool isTersedia = item['status_barang'] == 'tersedia';
    
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
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
            children: [
              Text(
                item['nama_barang'] ?? 'Nama Alat',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Badge Kategori (Border Oranye)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFE67E22)),
                    ),
                    child: Text(
                      item['kategori'] ?? 'Keselamatan Kerja (K3)',
                      style: const TextStyle(color: Color(0xFFE67E22), fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // Tombol Pinjam (Peach/Orange Muda)
                  ElevatedButton(
                    onPressed: isTersedia ? () => widget.onTambahKeranjang(item) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD1A4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    ),
                    child: const Text(
                      'Pinjam',
                      style: TextStyle(color: Color(0xFFE67E22), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Label "Tersedia" Hijau di pojok
        if (isTersedia)
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFA7F3D0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Tersedia",
                style: TextStyle(color: Color(0xFF065F46), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}