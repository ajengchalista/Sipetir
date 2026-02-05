import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> tambahKategori({
    required String nama,
    required String keterangan,
  }) async {
    await _supabase.from('kategori').insert({
      'nama_kategori': nama,
      'keterangan': keterangan,
    });
  }

  Future<void> updateKategori({
    required String id,
    required String nama,
    required String keterangan,
  }) async {
    await _supabase.from('kategori').update({
      'nama_kategori': nama,
      'keterangan': keterangan,
    }).match({'kategori_id': id}); // Mencocokkan ID kategori
  }
}