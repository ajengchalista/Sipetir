import 'package:flutter/material.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EB), // Background cream konsisten
      body: Column(
        children: [
          // HEADER MELENGKUNG (Sinkron dengan Dashboard)
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 25,
              right: 25,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF47521),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () =>
                      Navigator.pop(context), // Fungsi kembali ke Dashboard
                ),
                const SizedBox(width: 10),
                const Text(
                  'Laporan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // CONTENT (Full Code Form Anda)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Laporan
                  const Text(
                    'Form Laporan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF7A21),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card Form Laporan
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E6), // Theme krem
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFB385)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Jenis Laporan'),
                        _buildDropdownField('Pilih Jenis Laporan'),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Tgl Pinjam'),
                                  _buildDateField(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Tgl Kembali'),
                                  _buildDateField(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        _buildLabel('Kategori Alat'),
                        _buildDropdownField('Pilih Kategori'),
                        const SizedBox(height: 15),

                        _buildLabel('Status'),
                        _buildDropdownField('Pilih Status'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tombol Cetak Sekarang
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logika cetak
                      },
                      icon: const Icon(Icons.print, color: Colors.white),
                      label: const Text(
                        'Cetak Sekarang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A21),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ), // Space agar tidak tertutup navbar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper Anda (Tetap Sesuai)
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4A4A4A),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFF7A21)),
          items: const [],
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB385)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('2026-01-30', style: TextStyle(fontSize: 13)), // Dummy date
          Icon(Icons.calendar_today, size: 16, color: Color(0xFFFF7A21)),
        ],
      ),
    );
  }
}
