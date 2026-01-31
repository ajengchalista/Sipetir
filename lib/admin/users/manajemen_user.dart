import 'package:flutter/material.dart';
import 'package:sipetir/admin/users/tambah_user.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';

class ManajemenUserPage extends StatefulWidget {
  const ManajemenUserPage({super.key});

  @override
  State<ManajemenUserPage> createState() => _ManajemenUserPageState();
}

class _ManajemenUserPageState extends State<ManajemenUserPage> {
  final Color orange = const Color(0xFFF37021);
  final Color bg = const Color(0xFFFFF2E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      // ================= APPBAR =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Stack(
          children: [
            const HeaderCustom(title: 'Manajemen User', subtitle: 'admin'),

            // 🔙 ICON KEMBALI (POLOS, SAMA SEPERTI DASHBOARD)
            Positioned(
              top: 50,
              left: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // 👤 ICON PROFIL (KANAN ATAS)
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // SEARCH & FILTER
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: orange.withOpacity(0.5)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Username',
                        hintStyle: TextStyle(color: orange.withOpacity(0.5)),
                        icon: Icon(Icons.search, color: orange),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: orange.withOpacity(0.5)),
                  ),
                  child: Icon(Icons.tune, color: orange, size: 25),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // TOMBOL TAMBAH USER
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TambahUserDialog(orange: orange, bg: bg),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person_add_alt_1_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Tambah User Baru',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            _buildUserCard(
              'AF',
              'Ajeng Febria',
              'AjengPargoy@brantas.com',
              'Admin',
            ),
            _buildUserCard(
              'LA',
              'Lailahailla anta',
              'AjengPargoy@brantas.com',
              'Petugas',
            ),
            _buildUserCard(
              'BU',
              'BUBIBU',
              'AjengPargoy@brantas.com',
              'Petugas',
            ),
            _buildUserCard(
              'HA',
              'Hahaha',
              'AjengPargoy@brantas.com',
              'Peminjam',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(
    String initial,
    String nama,
    String email,
    String role,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDE2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: orange.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF7CBB1),
            radius: 25,
            child: Text(
              initial,
              style: TextStyle(color: orange, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: orange.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            role,
            style: TextStyle(
              color: orange.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
