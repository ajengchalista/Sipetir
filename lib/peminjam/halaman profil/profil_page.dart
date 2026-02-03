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

  Future<void> _logout() async {
    await supabase.auth.signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
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
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // AVATAR
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF7A21),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: 80,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildProfileField('Username', 'Selly@gmail.com'),
                  const SizedBox(height: 20),
                  _buildProfileField(
                    'Password',
                    '**********',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField('Status', 'Admin'),

                  const SizedBox(height: 50),

                  // ✅ TOMBOL LOGOUT + DIALOG
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

  Widget _buildProfileField(
    String label,
    String value, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFF7A21),
            fontSize: 16,
            fontWeight: FontWeight.w500,
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
            style: TextStyle(
              color: isPassword ? const Color(0xFFFF7A21) : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
