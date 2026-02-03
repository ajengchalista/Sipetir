import 'package:flutter/material.dart';
import '../services/kategori_service.dart';

class TambahKategoriBaru extends StatefulWidget {
  final VoidCallback onSuccess;

  const TambahKategoriBaru({super.key, required this.onSuccess});

  @override
  State<TambahKategoriBaru> createState() => _TambahKategoriBaruState();
}

class _TambahKategoriBaruState extends State<TambahKategoriBaru> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  final KategoriService _kategoriService = KategoriService();
  bool isLoading = false;

  @override
  void dispose() {
    namaController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  Future<void> simpanKategori() async {
    if (namaController.text.isEmpty || keteranganController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }

    setState(() => isLoading = true);

    try {
      await _kategoriService.tambahKategori(
        nama: namaController.text,
        keterangan: keteranganController.text,
      );

      widget.onSuccess();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan kategori: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tambah Kategori Baru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            const Text('Nama Kategori'),
            const SizedBox(height: 6),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 14),
            const Text('Keterangan'),
            const SizedBox(height: 6),
            TextField(
              controller: keteranganController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : simpanKategori,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
