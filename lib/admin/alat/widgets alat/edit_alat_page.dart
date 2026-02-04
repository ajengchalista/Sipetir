import 'dart:io';

import 'package:flutter/foundation.dart';
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

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedXFile;
  bool _isUploading = false;

  final List<String> daftarKategori = [
    'Alat Ukur Listrik',
    'Peralatan Mekanik',
    'Alat Analisis & Quality Check',
    'Keselamatan Kerja (K3)',
  ];

  String? selectedKategori;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    // Mengambil data awal
    namaController = TextEditingController(
      text: widget.data['nama_barang'] ?? "",
    );
    kodeController = TextEditingController(
      text: widget.data['kode_alat'] ?? "",
    );
    imageUrl = widget.data['gambar_url'];

    // Inisialisasi kategori
    String kategoriAwal =
        widget.data['kategori']?.toString() ?? 'Alat Ukur Listrik';
    selectedKategori = daftarKategori.contains(kategoriAwal)
        ? kategoriAwal
        : daftarKategori[0];
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
    // 1. PERBAIKAN ID: Mencari ID dengan segala kemungkinan nama field
    final dynamic idAlat =
        widget.data['id'] ??
        widget.data['id_alat'] ??
        widget.data['id_barang'] ??
        widget.data['item_id'];

    if (idAlat == null) {
      _showSnackBar(
        "Error: Data ID tidak terbaca! Pastikan 'id' ada di tabel.",
        Colors.red,
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final supabase = Supabase.instance.client;
      String? finalImageUrl = imageUrl;

      // 2. PERBAIKAN BUCKET: Nama harus 'GAMBAR_ALAT' sesuai dashboard
      const String myBucket = 'GAMBAR_ALAT';

      if (_selectedXFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = 'alat/$fileName';

        if (kIsWeb) {
          final bytes = await _selectedXFile!.readAsBytes();
          await supabase.storage
              .from(myBucket)
              .uploadBinary(
                path,
                bytes,
                fileOptions: const FileOptions(
                  contentType: 'image/jpeg',
                  upsert: true,
                ),
              );
        } else {
          await supabase.storage
              .from(myBucket)
              .upload(path, _selectedXFile!.path as File);
        }
        finalImageUrl = supabase.storage.from(myBucket).getPublicUrl(path);
      }

      // 3. Update ke Tabel 'alat'
      await supabase
          .from('alat')
          .update({
            'nama_barang': namaController.text,
            'kode_alat': kodeController.text,
            'kategori': selectedKategori,
            'gambar_url': finalImageUrl,
          })
          .eq('id', idAlat);

      if (mounted) {
        Navigator.pop(context, true);
        _showSnackBar("Berhasil memperbarui data!", Colors.green);
      }
    } catch (e) {
      if (mounted) _showSnackBar("Gagal: $e", Colors.red);
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
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF39C12).withOpacity(0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedKategori,
              isExpanded: true,
              items: daftarKategori
                  .map((String v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (val) => setState(() => selectedKategori = val),
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
