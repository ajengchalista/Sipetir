import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> tambahKategori({
    required String nama,
    required String keterangan,
  }) async {
    await _supabase.from('kategori').insert({
      'nama': nama,
      'keterangan': keterangan,
    });
  }
}
