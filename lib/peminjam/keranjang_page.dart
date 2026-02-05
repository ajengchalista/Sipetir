import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/theme/app_colors.dart';

class KeranjangPage extends StatefulWidget {
  final List<Map<String, dynamic>> keranjangItems;
  final VoidCallback onClear;

  const KeranjangPage({super.key, required this.keranjangItems, required this.onClear});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = false;

  Future<void> _processCheckout() async {
    if (widget.keranjangItems.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser!.id;

      final peminjaman = await supabase.from('peminjaman').insert({
        'user_id': userId,
        'tanggal_pinjam': DateTime.now().toIso8601String(),
        'tanggal_kembali': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        'status': 'disetujui',
      }).select().single();

      final pinjamId = peminjaman['pinjam_id'];

      final details = widget.keranjangItems.map((item) => {
        'pinjam_id': pinjamId,
        'barang_id': item['alat_id'],
        'jumlah': 1,
      }).toList();

      await supabase.from('detail_peminjaman').insert(details);

      for (var item in widget.keranjangItems) {
        await supabase.from('Alat').update({'status_barang': 'dipinjam'}).eq('alat_id', item['alat_id']);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Peminjaman Berhasil!"), backgroundColor: Colors.green)
        );
        widget.onClear(); 
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EB),
      appBar: AppBar(
        title: const Text('Keranjang Pinjam', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFFE5D1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: widget.keranjangItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_rounded, size: 100, color: Colors.orange.shade200),
                  const SizedBox(height: 20),
                  const Text("Keranjang kosong,", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const Text("belum ada alat yang dipilih", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.keranjangItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.keranjangItems[index];
                      return ListTile(
                        leading: const Icon(Icons.build, color: Color(0xFFFF7A21)),
                        title: Text(item['nama_barang']),
                        subtitle: Text(item['kode_alat'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.keranjangItems.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _processCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A21),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Konfirmasi Pinjam Sekarang",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}