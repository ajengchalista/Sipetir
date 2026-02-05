import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditAlatPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditAlatPage({super.key, required this.data});

  @override
  State<EditAlatPage> createState() => _EditAlatPageState();
}

class _EditAlatPageState extends State<EditAlatPage> {
  late TextEditingController namaController;
  late TextEditingController kodeController;
  List<Map<String, dynamic>> listKategoriDB = [];

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedXFile;
  bool _isUploading = false;

  final List<String> daftarKategori = [
    'Alat Ukur Listrik',
    'Peralatan Mekanik',
    'Alat Analisis & Quality Check',
    'Keselamatan Kerja (K3)',
  ];

  String? selectedKategoriId;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data awal
    namaController = TextEditingController(text: widget.data['nama_barang']);
    kodeController = TextEditingController(text: widget.data['kode_alat']);
    imageUrl = widget.data['gambar_url'];
    selectedKategoriId = widget.data['kategori_id']; // ID yang sudah ada di baris data
    
    _loadKategori(); // Panggil fungsi ambil kategori
  }

  Future<void> _loadKategori() async {
    final data = await Supabase.instance.client.from('kategori').select();
    setState(() {
      listKategoriDB = List<Map<String, dynamic>>.from(data);
    });
  }

  @override
  void dispose() {
    namaController.dispose();
    kodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _selectedXFile = pickedFile);
    }
  }

  Future<void> _updateData() async {
  setState(() => _isUploading = true);

  try {
    final supabase = Supabase.instance.client;
    String? finalImageUrl = imageUrl;
    const String myBucket = 'media_alat'; // Nama bucket sesuai permintaan

    if (_selectedXFile != null) {
      final bytes = await _selectedXFile!.readAsBytes();
      final path = 'alat/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from(myBucket).uploadBinary(
        path, 
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true)
      );
      finalImageUrl = supabase.storage.from(myBucket).getPublicUrl(path);
    }

    // CRUD Update: Panggil nama kolom sesuai tabel Alat
    await supabase.from('Alat').update({
      'nama_barang': namaController.text,
      'kode_alat': kodeController.text,
      'kategori_id': selectedKategoriId, // ID hasil pilihan dropdown dinamis
      'gambar_url': finalImageUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('alat_id', widget.data['alat_id']); // Pakai kolom alat_id

    if (mounted) Navigator.pop(context, true);
  } catch (e) {
    _showSnackBar("Gagal: $e", Colors.red);
  } finally {
    if (mounted) setState(() => _isUploading = false);
  }
}

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFEE7D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Alat",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE67E22),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 140,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _selectedXFile != null
                          ? Image.network(
                              _selectedXFile!.path,
                              fit: BoxFit.cover,
                            )
                          : (imageUrl != null
                                ? Image.network(imageUrl!, fit: BoxFit.cover)
                                : const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  )),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Edit Gambar Alat",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _buildFieldGroup("Nama Alat", namaController),
              const SizedBox(height: 15),
              _buildFieldGroup("Kode Alat", kodeController),
              const SizedBox(height: 15),
              _buildDropdownGroup("Kategori"),
              const SizedBox(height: 30),
              _isUploading
                  ? const CircularProgressIndicator(color: Color(0xFFE67E22))
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFF39C12)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "Batal",
                              style: TextStyle(color: Color(0xFFE67E22)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _updateData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE67E22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "Simpan",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldGroup(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(controller: controller, decoration: _inputDecoration()),
      ],
    );
  }

  Widget _buildDropdownGroup(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedKategoriId, // Pakai ID sebagai value internal
              isExpanded: true,
              hint: const Text("Pilih Kategori"),
              items: listKategoriDB.map((kat) {
                return DropdownMenuItem<String>(
                  value: kat['kategori_id'].toString(), // ID kolom
                  child: Text(kat['nama_kategori'].toString()), // Nama yang tampil
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedKategoriId = val),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFFF39C12).withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE67E22)),
      ),
    );
  }
}
