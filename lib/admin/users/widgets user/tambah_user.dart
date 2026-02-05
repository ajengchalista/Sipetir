import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddUserPage extends StatefulWidget {
  final Color orange;
  final Color bg;

  const AddUserPage({super.key, required this.orange, required this.bg});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Controller Baru
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedRole;
  bool _isLoading = false;

  final List<String> _roles = ['Admin', 'Petugas', 'Peminjam'];
  final SupabaseClient supabase = Supabase.instance.client;

Future<void> _simpanUser() async {
  if (!_formKey.currentState!.validate()) return;
  if (_selectedRole == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih Role!')));
    return;
  }

  setState(() => _isLoading = true);

  try {
    // 1. Create the Auth User
    final AuthResponse res = await supabase.auth.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      data: {
        'username': _usernameController.text.trim(),
        'role': _selectedRole!.toLowerCase(),
      },
    );

    if (res.user != null) {
      // 2. Use UPSERT instead of INSERT
      // This will update the row if the Trigger already created it, 
      // or create it if it doesn't exist.
      await supabase.from('users').upsert({
        'id': res.user!.id, 
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole!.toLowerCase(),
      }, onConflict: 'id'); // Tells Supabase to update if ID exists

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User berhasil dibuat!'), backgroundColor: Colors.green),
        );
      }
    }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        String errorMessage = e.toString();
        // Sederhanakan pesan error untuk user
        if (errorMessage.contains('user_already_exists')) {
          errorMessage = "Email sudah terdaftar!";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $errorMessage'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color modalColor = Color(0xFFFFF2E7);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: modalColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tambah User Baru",
                  style: TextStyle(
                    color: widget.orange,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel("Username"),
                _buildTextField(_usernameController, "Username"),

                const SizedBox(height: 15),

                _buildLabel("Email"), // Field Email Baru
                _buildTextField(_emailController, "example@mail.com", isEmail: true),

                const SizedBox(height: 15),

                _buildLabel("Password"),
                _buildTextField(
                  _passwordController,
                  "Minimal 6 karakter",
                  isPassword: true,
                ),

                const SizedBox(height: 15),

                _buildLabel("Role"),
                _buildDropdownField(),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: widget.orange),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text("Batal", style: TextStyle(color: widget.orange, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _simpanUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- HELPER ----------

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPassword = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (val) {
        if (val == null || val.isEmpty) return 'Wajib diisi';
        if (isEmail && !val.contains('@')) return 'Email tidak valid';
        if (isPassword && val.length < 6) return 'Password minimal 6 karakter';
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF2A379)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: widget.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF2A379)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: widget.orange, width: 2),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: widget.orange, size: 30),
      hint: const Text("Pilih Role", style: TextStyle(color: Colors.grey, fontSize: 14)),
      items: _roles.map((String role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
      onChanged: (newValue) => setState(() => _selectedRole = newValue),
    );
  }
}