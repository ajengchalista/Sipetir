import 'package:flutter/material.dart';

class EditPengembalianDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(dynamic id, Map<String, dynamic> updates) onSave;
  
  const EditPengembalianDialog({
    super.key,
    required this.data,
    required this.onSave,
  });

  @override
  State<EditPengembalianDialog> createState() => _EditPengembalianDialogState();
}

class _EditPengembalianDialogState extends State<EditPengembalianDialog> {
  late TextEditingController _tglController,
      _kondisiController,
      _dendaController;

  @override
  void initState() {
    super.initState();
    _tglController = TextEditingController(
      text: widget.data['tanggal_kembali_asli'] ?? '',
    );
    _kondisiController = TextEditingController(
      text: widget.data['kondisi_saat_dikembalikan'] ?? '',
    );
    _dendaController = TextEditingController(
      text: widget.data['denda']?.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _tglController.dispose();
    _kondisiController.dispose();
    _dendaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7F2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit pengembalian",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7A21),
                ),
              ),
              _buildField("Tgl kembali", _tglController),
              _buildField("Kondisi", _kondisiController),
              _buildField("Denda", _dendaController),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF7A21)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Color(0xFFFF7A21)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          widget.onSave(widget.data['kembali_id'], {
                            'tanggal_kembali_asli': _tglController.text,
                            'kondisi_saat_dikembalikan':
                                _kondisiController.text,
                            'denda': int.tryParse(_dendaController.text) ?? 0,
                          }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A21),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 5),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFF7A21).withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}