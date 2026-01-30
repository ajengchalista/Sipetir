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
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;
      if (user == null) throw Exception();

      final userData = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('user_id', user.id)
          .maybeSingle();

      if (userData == null) throw Exception();
      final role = userData['role'];

      if (!mounted) return;

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdminPage()),
        );
      } else if (role == 'petugas') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPetugasPage()),
        );
      } else if (role == 'penyewa') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPeminjamPage()),
        );
      }
    } catch (e) {
      _showErrorBanner();
    } finally {
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
    // Menggunakan LayoutBuilder untuk mendapatkan ukuran layar yang presisi
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            // Memastikan konten bisa di-scroll jika layar sangat pendek (misal hp lama)
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    ), // Jarak 10% dari atas
                    // Logo dibuat responsive (maksimal 25% dari tinggi layar)
                    Image.asset(
                      'assets/images/logo.png',
                      height: constraints.maxHeight * 0.25,
                      fit: BoxFit.contain,
                    ),

                    // Spacer diganti dengan Expanded agar LoginCard menempel di bawah
                    const Expanded(child: SizedBox(height: 20)),

                    /// LOGIN CARD
                    // Tetap menggunakan widget LoginCard kamu tanpa mengubah isinya
                    LoginCard(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),
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
