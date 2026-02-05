import 'package:flutter/material.dart';

class EditCategoryForm extends StatefulWidget {
  final String initialNama;
  final String initialKeterangan;
  // Kita ubah onSave agar hanya mengirim data, bukan Future
  final Function(String nama, String keterangan) onSave;

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
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Color(0xFFF58220)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (namaController.text.isEmpty ||
                            keteranganController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Field tidak boleh kosong"),
                            ),
                          );
                          return;
                        }

                        // Kirim data kembali ke halaman yang memanggil dialog ini
                        widget.onSave(
                          namaController.text,
                          keteranganController.text,
                        );
                        Navigator.pop(context);
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
