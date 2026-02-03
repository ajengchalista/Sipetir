import 'package:supabase_flutter/supabase_flutter.dart';

class PengembalianService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil data pengembalian
  Future<List<Map<String, dynamic>>> getPengembalian() async {
    final response = await _supabase
        .from('pengembalian') // Pastikan nama tabel sesuai di Supabase
        .select('*, peminjaman(nama_alat, nama_peminjam)') // Contoh join tabel
        .order('tanggal_kembali', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Fungsi untuk memproses pengembalian baru
  Future<void> prosesPengembalian({
    required int peminjamanId,
    required String kondisi,
  }) async {
    await _supabase.from('pengembalian').insert({
      'id_peminjaman': peminjamanId,
      'kondisi_barang': kondisi,
      'tanggal_kembali': DateTime.now().toIso8601String(),
    });
  }
}