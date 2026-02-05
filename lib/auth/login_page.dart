import 'package:flutter/material.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/peminjam/dashboard/peminjam.dart';
import 'package:sipetir/petugas/dashboard/dashboard_petugas_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import '../auth/widgets/login_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      // 1. Auth Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;
      if (user == null) throw Exception("Login gagal");

      // 2. Ambil Role dari tabel public.users
      final userData = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (userData == null) throw Exception("Data profil tidak ditemukan");

      final String role = userData['role'].toString().toLowerCase();

      if (!mounted) return;

      // 3. Navigasi Langsung (Manual)
      Widget targetPage;

      if (role == 'admin') {
        targetPage = const DashboardAdminPage();
      } else if (role == 'petugas') {
        targetPage = const DashboardPetugasPage();
      } else {
        targetPage = const DashboardPeminjamPage(); // Default untuk peminjam
      }

      // Pindah halaman dan hapus halaman login dari stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email/Password salah atau profil belum ada"),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),

                    Image.asset(
                      'assets/images/logo.png',
                      height: constraints.maxHeight * 0.55,
                      fit: BoxFit.contain,
                    ),

                    Transform.translate(
                      offset: const Offset(25, -230),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 56),
                        child: Text(
                          "Penyewaan Alat Teknisi Pembangkit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(221, 255, 91, 3),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),

                    const Expanded(child: SizedBox(height: 40)),

                    LoginCard(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
