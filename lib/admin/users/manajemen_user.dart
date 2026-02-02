import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/admin/users/tambah_user.dart';
import 'package:sipetir/admin/halaman%20profil/profil_page.dart';

class ManajemenUserPage extends StatefulWidget {
  const ManajemenUserPage({super.key});

  @override
  State<ManajemenUserPage> createState() => _ManajemenUserPageState();
}

class _ManajemenUserPageState extends State<ManajemenUserPage> {
  final Color orange = const Color(0xFFF37021);
  final Color bgKrem = const Color(0xFFF9EFE7);
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fungsi untuk mengambil data dari Supabase
  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await supabase
          .from('users')
          .select()
          .order('username', ascending: true);

      setState(() {
        _users = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error Fetch: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgKrem,
      body: Column(
        children: [
          // Header Oranye Melengkung
          Container(
            height: 140,
            padding: const EdgeInsets.only(top: 50, left: 10, right: 20),
            decoration: BoxDecoration(
              color: orange,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Manajemen Pengguna',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
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
              ],
            ),
          ),

          // Konten Body
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchUsers,
              color: orange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Search & Filter
                    Row(
                      children: [
                        Expanded(child: _buildSearchField()),
                        const SizedBox(width: 10),
                        _buildFilterButton(),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tombol Tambah User Baru
                    _buildAddButton(),

                    const SizedBox(height: 25),

                    // List User
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(color: orange),
                          )
                        : _users.isEmpty
                        ? const Center(child: Text("Tidak ada data user"))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              final user = _users[index];
                              return _buildUserCard(
                                (user['username'] ?? "U")[0].toUpperCase(),
                                user['username'] ?? "User",
                                user['role'] ?? "Peminjam",
                                "user@brantas.com",
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: orange.withOpacity(0.5)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Username',
          hintStyle: TextStyle(color: orange.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: orange.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: orange.withOpacity(0.5)),
      ),
      child: Icon(Icons.tune, color: orange, size: 25),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () async {
          // PERBAIKAN: Memanggil TambahUserDialog, bukan TambahAlatPage
          final result = await showDialog(
            context: context,
            builder: (_) => TambahAlatPage(orange: orange, bg: bgKrem),
          );

          // Jika simpan berhasil (Navigator.pop mengirim true), refresh data
          if (result == true) {
            _fetchUsers();
          }
        },
        icon: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
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
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(
    String initial,
    String nama,
    String role,
    String email,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgKrem,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar Kotak
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7CBB1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: TextStyle(
                    color: orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Nama & Email
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
                    Text(email, style: TextStyle(color: orange, fontSize: 13)),
                  ],
                ),
              ),
              // Badge Role
              Text(
                role,
                style: TextStyle(
                  color: orange.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Tombol Aksi Edit & Hapus
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit_note, color: orange),
                  label: Text("Edit", style: TextStyle(color: orange)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: orange.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    "Hapus",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
