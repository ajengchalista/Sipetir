import 'package:flutter/material.dart';
import 'package:sipetir/widgets/header_custom.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/widgets/dialog/logout_dialog.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  
  // Variabel untuk menampung data user
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  // --- FUNGSI AMBIL DATA USER DARI LOGIN SESSION ---
Future<void> _getProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final data = await supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .single();

        setState(() {
          // Buat salinan Map agar bisa dimodifikasi (mutable)
          _userData = Map<String, dynamic>.from(data);
          
          // JIKA email di public.users kosong, ambil dari auth.currentUser
          if (_userData?['email'] == null || _userData?['email'] == '') {
            _userData?['email'] = user.email; 
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error profile: $e"); // Debug info
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat profil: $e'), 
            backgroundColor: Colors.red
          ),
        );
      }
      setState(() => _isLoading = false);
    } // Kurung tutup blok try tadi ketinggalan di kode Anda
  }

  // --- FUNGSI LOGOUT ---
  Future<void> _logout() async {
    try {
      await supabase.auth.signOut();
      if (!mounted) return;
      // Kembali ke login dan hapus semua history page sebelumnya
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan inisial untuk avatar (contoh: 'C' dari 'Caca')
    String initial = _userData?['username']?.toString().substring(0, 1).toUpperCase() ?? '?';
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Column(
        children: [
          // HEADER
          Stack(
            children: [
              const HeaderCustom(title: 'Profil Pengguna'),
              Positioned(
                top: 50,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A21)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // AVATAR DINAMIS
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF7A21),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // DATA FIELD DINAMIS
                      _buildProfileField('Username', _userData?['username'] ?? '-'),
                      const SizedBox(height: 20),
                      _buildProfileField('Email', _userData?['email'] ?? '-'),
                      const SizedBox(height: 20),
                      _buildProfileField('Role Status', (_userData?['role'] ?? 'Peminjam').toString().toUpperCase()),

                      const SizedBox(height: 50),

                      // TOMBOL LOGOUT
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showLogoutDialog(context: context, onConfirm: _logout);
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7A21),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... (Tetap sama seperti kode lama Anda untuk styling)
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFF7A21),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF2E9),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFFFCCAC)),
          ),
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ),
      ],
    );
  }
}