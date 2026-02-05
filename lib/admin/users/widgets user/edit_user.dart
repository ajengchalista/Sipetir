import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditUserPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditUserPage({super.key, required this.userData});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late String _selectedRole;

  bool _isLoading = false;
  final List<String> _roles = ['admin', 'petugas', 'peminjam'];

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controller dengan data dari widget.userData
    _namaController = TextEditingController(text: widget.userData['username'] ?? '');
    
    // Perbaikan: Menggunakan _emailController yang sudah dideklarasikan
    // Pastikan key 'email' sesuai dengan select query di halaman ManajemenUser
    _emailController = TextEditingController(text: widget.userData['email'] ?? '');

    // Inisialisasi Role
    String rawRoleFromDb = (widget.userData['role'] ?? 'peminjam').toString().toLowerCase();
    _selectedRole = _roles.contains(rawRoleFromDb) ? rawRoleFromDb : 'peminjam';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final String userId = widget.userData['id'];
      final String newEmail = _emailController.text.trim();

      // Update tabel public.users
      await supabase
          .from('users')
          .update({
            'username': _namaController.text.trim(),
            'email': newEmail,
            'role': _selectedRole.toLowerCase(),
          })
          .eq('id', userId);

      if (mounted) {
        // Mengirimkan nilai 'true' agar halaman sebelumnya tahu data telah berubah dan melakukan refresh
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil memperbarui data'), 
            backgroundColor: Colors.green
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'), 
            backgroundColor: Colors.red
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                    color: Color(0xFFE67E22)
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabel('Nama Lengkap'),
                _buildTextField(_namaController),
                const SizedBox(height: 16),
                _buildLabel('Email'),
                _buildTextField(_emailController),
                const SizedBox(height: 16),
                _buildLabel('Role'),
                _buildDropdownRole(),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Helpers ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text, 
        style: const TextStyle(
          fontSize: 14, 
          color: Colors.black87, 
          fontWeight: FontWeight.w600
        )
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFFE67E22).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE67E22), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownRole() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE67E22).withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          isExpanded: true,
          items: _roles.map((val) => DropdownMenuItem(
            value: val, 
            child: Text(
              val[0].toUpperCase() + val.substring(1), 
              style: const TextStyle(color: Color(0xFFE67E22))
            )
          )).toList(),
          onChanged: (val) => setState(() => _selectedRole = val!),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE67E22)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Batal', 
              style: TextStyle(color: Color(0xFFE67E22), fontWeight: FontWeight.bold)
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _updateUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE67E22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : const Text(
                    'Simpan', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
          ),
        ),
      ],
    );
  }
}