import 'package:flutter/material.dart';
import 'package:sipetir/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DaftarAlatPage extends StatefulWidget {
  // Callback untuk mengirim data ke keranjang di halaman utama
  final Function(Map<String, dynamic>) onTambahKeranjang;

  const DaftarAlatPage({super.key, required this.onTambahKeranjang});

  @override
  State<DaftarAlatPage> createState() => _DaftarAlatPageState();
}

class _DaftarAlatPageState extends State<DaftarAlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> _alatStream;

  @override
  void initState() {
    super.initState();
    // Mengambil data langsung dari tabel Alat
    _alatStream = supabase
        .from('Alat')
        .stream(primaryKey: ['alat_id'])
        .order('nama_barang', ascending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _alatStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryOrange),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada alat tersedia.",
                        style: TextStyle(color: AppColors.greyText)),
                  );
                }

                final dataAlat = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: dataAlat.length,
                  itemBuilder: (context, index) {
                    return _buildAlatCard(dataAlat[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
      decoration: const BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Pilih Alat',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.white),
                  ),
                  Text(
                    'Silahkan pilih alat yang ingin dipinjam',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.shopping_bag_outlined, color: AppColors.white, size: 25),
              )
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Katalog Alat',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAlatCard(Map<String, dynamic> item) {
    // Logika status barang
    bool isTersedia = item['status_barang'] == 'tersedia';
    String inisial = item['nama_barang'].toString().substring(0, 1).toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isTersedia ? AppColors.mediumOrange : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    inisial,
                    style: TextStyle(
                      color: isTersedia ? AppColors.primaryOrange : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama_barang'] ?? 'Nama Alat',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item['kode_alat'] ?? '-',
                        style: const TextStyle(fontSize: 13, color: AppColors.greyText),
                      ),
                    ],
                  ),
                ),
                // Badge Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isTersedia ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isTersedia ? "Tersedia" : "Dipinjam",
                    style: TextStyle(
                      fontSize: 10,
                      color: isTersedia ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Tombol Pinjam
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isTersedia 
                  ? () => widget.onTambahKeranjang(item) // Memanggil fungsi tambah keranjang
                  : null, // Disable jika tidak tersedia
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  isTersedia ? 'Pinjam Sekarang' : 'Tidak Tersedia',
                  style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}