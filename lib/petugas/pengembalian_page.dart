import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  String selectedKondisi = 'Baik';

  Future<void> _processSimpanPengembalian(String pinjamId, String kondisi, DateTime waktuKembali, int denda) async {
    try {
      await supabase.from('pengembalian').insert({
        'pinjam_id': pinjamId,
        'tanggal_kembali_asli': waktuKembali.toIso8601String(),
        'kondisi_saat_dikembalikan': kondisi.toLowerCase(),
        'denda': denda,
      });

      // Update status jadi dikembalikan (selesai)
      await supabase.from('peminjaman').update({'status': 'disetujui'}).eq('pinjam_id', pinjamId);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengembalian Berhasil Dikonfirmasi'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showKonfirmasiDialog(Map<String, dynamic> data) {
    // Penanganan jika tanggal_kembali null
    DateTime deadline = data['tanggal_kembali'] != null 
        ? DateTime.parse(data['tanggal_kembali']) 
        : DateTime.now();
    DateTime inputTanggal = DateTime.now();
    TimeOfDay inputJam = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            DateTime waktuPengembalian = DateTime(
              inputTanggal.year, inputTanggal.month, inputTanggal.day,
              inputJam.hour, inputJam.minute,
            );

            Duration selisih = waktuPengembalian.difference(deadline);
            int menitTerlambat = selisih.inMinutes > 0 ? selisih.inMinutes : 0;
            int jamTerlambat = (menitTerlambat / 60).ceil();
            int tarifPerJam = 5000;
            int totalDenda = jamTerlambat * tarifPerJam;

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Konfirmasi\nPengembalian', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21))),
                      const SizedBox(height: 20),
                      const Text('Tgl & Jam Kembali', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(context: context, initialDate: inputTanggal, firstDate: DateTime(2020), lastDate: DateTime(2101));
                                if (picked != null) setDialogState(() => inputTanggal = picked);
                              },
                              child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFDECE2), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFF7A21))), child: Text(DateFormat('dd/MM/yyyy').format(inputTanggal))),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(context: context, initialTime: inputJam);
                                if (picked != null) setDialogState(() => inputJam = picked);
                              },
                              child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFDECE2), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFF7A21))), child: Text(inputJam.format(context))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Kondisi', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedKondisi,
                        decoration: InputDecoration(fillColor: const Color(0xFFFDECE2), filled: true, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFFF7A21)))),
                        items: ['Baik', 'Rusak', 'Hilang'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                        onChanged: (val) => setDialogState(() => selectedKondisi = val!),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFB385))),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text('Auto Calculated', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: menitTerlambat > 0 ? const Color(0xFFFF7A21) : Colors.green, borderRadius: BorderRadius.circular(10)), child: Text(menitTerlambat > 0 ? 'Terlambat' : 'Tepat Waktu', style: const TextStyle(color: Colors.white, fontSize: 10))),
                            ]),
                            const SizedBox(height: 10),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Terlambat', style: TextStyle(color: Colors.grey, fontSize: 12)), Text('$jamTerlambat Jam', style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold))]),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Denda /Jam', style: TextStyle(color: Colors.grey, fontSize: 12)), Text('5.000', style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold))]),
                            ]),
                            const Divider(height: 20),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text('Total Denda', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              Text('Rp $totalDenda', style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _processSimpanPengembalian(data['pinjam_id'], selectedKondisi, waktuPengembalian, totalDenda), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A21), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: const EdgeInsets.symmetric(vertical: 15)), child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), child: Text('Daftar Pengembalian', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF7A21)))),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            // MENGGUNAKAN STATUS 'disetujui' agar data peminjaman yang sedang berlangsung muncul di sini
            stream: supabase.from('peminjaman').stream(primaryKey: ['pinjam_id']).eq('status', 'dikembalikan').order('tanggal_pinjam'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Tidak ada data pengembalian"));
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => _buildReturnCard(snapshot.data![index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReturnCard(Map<String, dynamic> data) {
    String tgl = data['tanggal_pinjam'] != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(data['tanggal_pinjam'])) : '-';

    return FutureBuilder(
      future: Future.wait([
        supabase.from('users').select('username').eq('id', data['user_id']).single(),
        supabase.from('detail_peminjaman').select('Alat(nama_barang)').eq('pinjam_id', data['pinjam_id']).maybeSingle(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> subSnapshot) {
        if (!subSnapshot.hasData) return const SizedBox(height: 100);
        final userData = subSnapshot.data![0] as Map<String, dynamic>;
        final detailData = subSnapshot.data![1] as Map<String, dynamic>?;
        String userName = userData['username'] ?? 'User';
        String namaAlat = (detailData != null && detailData['Alat'] != null) ? detailData['Alat']['nama_barang'] : 'Barang...';

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFB385)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 45, height: 45, decoration: const BoxDecoration(color: Color(0xFFFFE5D1), shape: BoxShape.circle), child: Center(child: Text(userName.substring(0, 1).toUpperCase(), style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(data['tingkatan_kelas'] ?? '-', style: const TextStyle(color: Colors.grey, fontSize: 13))])),
                  Text(tgl, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 15),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFE5D1), borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(namaAlat, style: const TextStyle(color: Color(0xFFFF7A21), fontWeight: FontWeight.bold)), const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFF7A21))])),
              const SizedBox(height: 15),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _showKonfirmasiDialog(data), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A21), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 15)), child: const Text('Konfirmasi Pengembalian', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            ],
          ),
        );
      },
    );
  }
}