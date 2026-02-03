import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  // Menambahkan parameter userData untuk menerima data dari halaman utama
  final Map<String, dynamic> userData;

  const EditUserPage({super.key, required this.userData});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late String _selectedRole;

  final List<String> _roles = ['Admin', 'Petugas', 'Peminjam'];
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    // Mengambil username untuk ditampilkan di Nama dan Email
    String currentUsername = widget.userData['username'] ?? '';

    // Inisialisasi controller dengan data yang dikirim dari halaman utama
    _namaController = TextEditingController(text: currentUsername);
    _emailController = TextEditingController(
      text: "${currentUsername.toLowerCase()}@gmail.com",
    );

    // Password akan otomatis mengisi 'selicantik' atau '1234567890'
    // tergantung isi dari database (widget.userData)
    _passwordController = TextEditingController(
      text: widget.userData['password']?.toString() ?? '',
    );

    // Pastikan role sesuai dengan list, jika tidak ada default ke 'Peminjam'
    _selectedRole = _roles.contains(widget.userData['role'])
        ? widget.userData['role']
        : 'Peminjam';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF1E7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit User',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE67E22),
                  ),
                ),
                const SizedBox(height: 24),

                _buildLabel('Nama Lengkap'),
                _buildTextField(_namaController),

                const SizedBox(height: 16),

                _buildLabel('Email'),
                _buildTextField(_emailController),

                const SizedBox(height: 16),

                _buildLabel('Password'),
                _buildPasswordField(),

                const SizedBox(height: 16),

                _buildLabel('Role'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE67E22).withOpacity(0.5),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFFE67E22),
                      ),
                      items: _roles.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Color(0xFFE67E22)),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRole = newValue!;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE67E22)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Color(0xFFE67E22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika simpan bisa ditambahkan di sini
                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE67E22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFFE67E22).withOpacity(0.7),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFFE67E22).withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE67E22), width: 2),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFFE67E22).withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE67E22), width: 2),
        ),
      ),
    );
  }
}
