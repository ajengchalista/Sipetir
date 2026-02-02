import 'package:flutter/material.dart';
import 'package:sipetir/admin/dashboard/dashboard_admin_page.dart';
import 'package:sipetir/admin/kategori/kategori_screen.dart';
import 'package:sipetir/admin/peminjaman/peminjaman_page.dart';
import 'package:sipetir/admin/pengembalian/pengembalian_page.dart';
import 'package:sipetir/admin/users/manajemen_user.dart';
import 'package:sipetir/peminjam/dashboard/peminjam.dart';
import 'package:sipetir/peminjam/manajemen_peminjaman_page.dart';
import 'package:sipetir/petugas/dashboard/dashboard_petugas_page.dart';
import 'package:sipetir/admin/alat/alat_page.dart';
import 'package:sipetir/auth/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetir/petugas/laporan/laporan_page.dart';
import 'package:sipetir/admin/halaman profil/profil_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lpexaemcxjlfgdayvxyx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwZXhhZW1jeGpsZmdkYXl2eHl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg2ODI5MDAsImV4cCI6MjA4NDI1ODkwMH0.nAJhj65Q4S25TtmaKFofrq-CVe5_eCU5X_jzGZ0fqCA',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIPETIR',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: const DashboardAdminPage(),
    );
  }
}
