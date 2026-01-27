import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_textfield.dart';
import 'login_button.dart';

class LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isLoading;

  const LoginCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "hi!, ayo login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          const Text("Username", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          LoginTextField(
            hint: "Username",
            controller: emailController,
          ),

          const SizedBox(height: 16),
          const Text("Password", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          LoginTextField(
            hint: "Password",
            isPassword: true,
            controller: passwordController,
          ),

          const SizedBox(height: 24),
          LoginButton(
            onPressed: isLoading ? () {} : onLogin,
          ),
        ],
      ),
    );
  }
}
