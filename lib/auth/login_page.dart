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
    debugPrint("LOGIN: tombol login ditekan");
    debugPrint("LOGIN: email = ${_emailController.text}");

    setState(() => _isLoading = true);

    try {
      debugPrint("LOGIN: mencoba login ke Supabase");

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        debugPrint("LOGIN ERROR: user null");
        throw Exception();
      }

      debugPrint("LOGIN SUCCESS: user id = ${user.id}");

      final userData = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('user_id', user.id)
          .maybeSingle();

      if (userData == null) {
        debugPrint("LOGIN ERROR: data user tidak ditemukan");
        throw Exception();
      }

      final role = userData['role'];
      debugPrint("LOGIN: role user = $role");

      if (!mounted) return;

      if (role == 'admin') {
        debugPrint("NAVIGASI: ke Dashboard Admin");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdminPage()),
        );
      } else if (role == 'petugas') {
        debugPrint("NAVIGASI: ke Dashboard Petugas");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPetugasPage()),
        );
      } else if (role == 'penyewa') {
        debugPrint("NAVIGASI: ke Dashboard Peminjam");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPeminjamPage()),
        );
      } else {
        debugPrint("LOGIN ERROR: role tidak dikenali");
      }
    } catch (e) {
      debugPrint("LOGIN FAILED: $e");
      _showErrorBanner();
    } finally {
      debugPrint("LOGIN: proses selesai");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorBanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Terjadi kesalahan / Data tidak sesuai")),
    );
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
