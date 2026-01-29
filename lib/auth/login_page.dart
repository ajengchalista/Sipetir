import 'package:flutter/material.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/peminjam/peminjam.dart';
import 'package:sipetir/petugas/dashboard/dashboard_petugas_page.dart';
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

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final response =
          await Supabase.instance.client.auth.signInWithPassword(
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
      } 
      else if (role == 'petugas') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPetugasPage()),
        );
      } else if (role == 'penyewa') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const DashboardPeminjamPage()),
        );
      }
    } catch (e) {
      _showErrorBanner();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorBanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Terjadi kesalahan / Data tidak sesuai"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Image.asset('assets/images/logo.png', height: 140),
          const Spacer(),

          /// ⬇️ KIRIM CONTROLLER & FUNCTION
          LoginCard(
            emailController: _emailController,
            passwordController: _passwordController,
            onLogin: _handleLogin,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
