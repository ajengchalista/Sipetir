import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/admin/users/widgets%20user/tambah_user.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';
import 'package:sipetir/admin/users/widgets user/edit_user.dart';
import 'package:sipetir/admin/users/dialog/delete_dialog.dart';

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
  List<Map<String, dynamic>> _filteredUsers = []; // Tambahkan ini
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await supabase
          .from('users')
          .select('id, username, email, role')
          .order('username', ascending: true);

      setState(() {
        _users = List<Map<String, dynamic>>.from(data);
        _filteredUsers = _users; // Defaultnya tampilkan semua
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetch: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _users;
    } else {
      results = _users
          .where(
            (user) => user["username"].toString().toLowerCase().contains(
              enteredKeyword.toLowerCase(),
            ),
          )
          .toList();
    }

    setState(() {
      _filteredUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgKrem,
      body: Column(
        children: [
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilPage()),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchUsers,
              color: orange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTopActions(),
                    const SizedBox(height: 25),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(color: orange),
                          )
                        : _filteredUsers
                              .isEmpty // Gunakan filteredUsers
                        ? const Center(child: Text("Data tidak ditemukan"))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                _filteredUsers.length, // Gunakan filteredUsers
                            itemBuilder: (context, index) {
                              final user =
                                  _filteredUsers[index]; // Gunakan filteredUsers
                              return _buildUserCard(user);
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

  Widget _buildTopActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: orange.withOpacity(0.5)),
                ),
                // Di dalam _buildTopActions() -> TextField
                child: TextField(
                  controller: _searchController, // Tambahkan controller
                  onChanged: (value) =>
                      _runFilter(value), // Tambahkan onChanged
                  decoration: InputDecoration(
                    hintText: 'Cari Username',
                    hintStyle: TextStyle(color: orange.withOpacity(0.5)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: orange.withOpacity(0.5),
                    ),
                    // Tambahkan tombol hapus (X) jika teks tidak kosong
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: orange),
                            onPressed: () {
                              _searchController.clear();
                              _runFilter('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: orange.withOpacity(0.5)),
              ),
              child: Icon(Icons.tune, color: orange),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () async {
              final res = await showDialog(
                context: context,
                builder: (_) => AddUserPage(orange: orange, bg: bgKrem),
              );
              if (res == true) _fetchUsers();
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
      ],
    );
  }

  Widget _buildUserCard(Map<String, dynamic> userData) {
    final String username = userData['username'] ?? "user";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7CBB1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : "?",
                  style: TextStyle(
                    color: orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      userData['email'] ??
                          "${username.toLowerCase()}@gmail.com",
                      style: TextStyle(color: orange, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  userData['role'] ?? "User",
                  style: TextStyle(
                    color: orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserPage(userData: userData),
                      ),
                    );

                    if (res == true) {
                      _fetchUsers();
                    }
                  },
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
                  onPressed: () async {
                    if (userData['id'] == null) return;

                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => const CustomDeleteDialog(),
                    );

                    if (confirm == true) {
                      try {
                        await supabase
                            .from('users')
                            .delete()
                            .eq('id', userData['id']);

                        // MENAMPILKAN NOTIFIKASI BERHASIL
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("User berhasil dihapus"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }

                        _fetchUsers();
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal hapus: $e")),
                          );
                        }
                      }
                    }
                  },
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
