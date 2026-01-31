import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditAlatPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditAlatPage({super.key, required this.data});

  @override
  State<EditAlatPage> createState() => _EditAlatPageState();
}

class _EditAlatPageState extends State<EditAlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late TextEditingController _namaController;
  late TextEditingController _kodeController;
  
  // Jika relasi kategori menggunakan ID (int), ubah String? menjadi int?
  dynamic _selectedKategoriId; 

  // Contoh list kategori (ID harus sesuai dengan yang ada di tabel relasi Kategori kamu)
  final List<Map<String, dynamic>> _kategoriOptions = [
    {'id': 1, 'nama': 'Peralatan'},
    {'id': 2, 'nama': 'Alat Ukur Listrik'},
    {'id': 3, 'nama': 'Peralatan Mekanik'},
    {'id': 4, 'nama': 'Alat Analisis & Quality check'},
    {'id': 5, 'nama': 'Keselamatan Kerja (K3)'},
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.data['nama_barang']?.toString() ?? '');
    _kodeController = TextEditingController(text: widget.data['kode_alat']?.toString() ?? '');
    
    // Ambil ID kategori dari data yang dikirim
    _selectedKategoriId = widget.data['id_kategori'] ?? widget.data['kategori_id'];
  }

  Future<void> _updateAlat() async {
    try {
      // PERHATIKAN: Nama kolom relasi di tabel Alat biasanya diawali 'id_' atau 'kategori_id'
      await supabase.from('Alat').update({
        'nama_barang': _namaController.text.trim(),
        'kode_alat': _kodeController.text.trim(),
        'id_kategori': _selectedKategoriId, // Kirim ID, bukan teks nama kategori
      }).eq('alat_id', widget.data['alat_id']); 

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alat berhasil diperbarui'), backgroundColor: Color(0xFFF0822D)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: Pastikan nama kolom relasi benar ($e)"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15), 
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(color: const Color(0xFFF9EFE5), borderRadius: BorderRadius.circular(40)),
      child: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Alat', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFFF0822D))),
              const SizedBox(height: 25),
              _buildLabel('Nama Alat'),
              _buildTextField(_namaController),
              const SizedBox(height: 20),
              _buildLabel('Kode Alat'),
              _buildTextField(_kodeController),
              const SizedBox(height: 20),
              _buildLabel('Kategori (Relasi)'),
              _buildDropdown(),
              const SizedBox(height: 40),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF0822D).withOpacity(0.6), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: _selectedKategoriId,
          isExpanded: true,
          hint: const Text("Pilih Kategori"),
          items: _kategoriOptions.map((cat) {
            return DropdownMenuItem(
              value: cat['id'],
              child: Text(cat['nama']),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedKategoriId = v),
        ),
      ),
    );
  }

  // ... Widget _buildButtons, _buildLabel, dan _buildTextField tetap sama seperti sebelumnya ...
  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Batal'))),
        const SizedBox(width: 15),
        Expanded(child: ElevatedButton(onPressed: _updateAlat, child: const Text('Simpan'))),
      ],
    );
  }
  
  Widget _buildLabel(String label) => Text(label, style: const TextStyle(fontWeight: FontWeight.bold));
  Widget _buildTextField(TextEditingController ctrl) => TextField(controller: ctrl);
}