import 'package:flutter/material.dart';

class EditCategoryForm extends StatefulWidget {
  final String initialNama;
  final String initialKeterangan;
  final Future<void> Function(String nama, String keterangan) onSave;

  const EditCategoryForm({
    super.key,
    required this.initialNama,
    required this.initialKeterangan,
    required this.onSave,
  });

  @override
  State<EditCategoryForm> createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
  late TextEditingController namaController;
  late TextEditingController keteranganController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.initialNama);
    keteranganController = TextEditingController(
      text: widget.initialKeterangan,
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: const Color(0xFFFEF2E8),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Kategori",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF58220),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Nama Kategori"),
              const SizedBox(height: 8),
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFF7F0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF58220)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Keterangan"),
              const SizedBox(height: 8),
              TextField(
                controller: keteranganController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFF7F0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF58220)),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSaving ? null : () => Navigator.pop(context),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Color(0xFFF58220)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              setState(() => isSaving = true);

                              try {
                                // WAJIB AWAIT BIAR DATA BENERAN KESIMPAN
                                await widget.onSave(
                                  namaController.text,
                                  keteranganController.text,
                                );

                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                setState(() => isSaving = false);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Gagal menyimpan: $e'),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF58220),
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
}
