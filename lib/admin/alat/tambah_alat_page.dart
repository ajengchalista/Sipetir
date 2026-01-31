import 'package:flutter/material.dart';

class TambahAlatPage extends StatefulWidget {
  const TambahAlatPage({super.key});

  @override
  State<TambahAlatPage> createState() => _TambahAlatPageState();
}

class _TambahAlatPageState extends State<TambahAlatPage> {
  // ===== CONTROLLER =====
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();

  // ===== STATE KATEGORI =====
  String? selectedKategori;

  // ===== ERROR MESSAGE =====
  String? errorMessage;

  final List<String> kategoriList = [
    'Alat Ukur Listrik',
    'Peralatan Mekanik',
    'Alat Analisis & Quality Check',
    'Keselamatan Kerja (K3)',
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryOrange = Color(0xFFF0822D);
    const Color backgroundKrem = Color(0xFFFFF5ED);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: const BoxDecoration(
        color: backgroundKrem,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tambah Alat Baru',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: primaryOrange,
            ),
          ),
          const SizedBox(height: 25),

          // Nama Alat
          _buildLabel("Nama Alat"),
          _buildTextField(primaryOrange, controller: namaController),

          const SizedBox(height: 15),

          // Kode Alat
          _buildLabel("Kode Alat"),
          _buildTextField(primaryOrange, controller: kodeController),

          const SizedBox(height: 15),

          // Kategori
          _buildLabel("Kategori"),
          _buildDropdownField(primaryOrange),

          // ===== PESAN ERROR =====
          if (errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 35),

          // Tombol
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryOrange, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: primaryOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // ===== VALIDASI (TETAP) =====
                    if (namaController.text.isEmpty ||
                        kodeController.text.isEmpty ||
                        selectedKategori == null) {
                      setState(() {
                        errorMessage = 'Isi data nya terlebih dahulu';
                      });
                      return;
                    }

                    setState(() {
                      errorMessage = null;
                    });

                    // ===== TAMBAHAN LOGIC (TANPA UBAH UI) =====
                    final Map<String, dynamic> alatBaru = {
                      'nama': namaController.text,
                      'kode': kodeController.text,
                      'kategori': selectedKategori,
                    };

                    Navigator.pop(context, alatBaru);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ===== LABEL =====
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  // ===== TEXTFIELD =====
  Widget _buildTextField(
    Color color, {
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFDF7F2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
      ),
    );
  }

  // ===== DROPDOWN =====
  Widget _buildDropdownField(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7F2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedKategori,
          hint: const Text('Pilih Kategori'),
          icon: Icon(Icons.arrow_drop_down_rounded, color: color, size: 40),
          items: kategoriList.map((kategori) {
            return DropdownMenuItem<String>(
              value: kategori,
              child: Text(kategori),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedKategori = value;
            });
          },
        ),
      ),
    );
  }
}
