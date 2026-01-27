import 'package:flutter/material.dart';

class HeaderCustom extends StatelessWidget {
  final String title;
  final String? subtitle; // Subtitle bersifat opsional

  const HeaderCustom({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 170, // Sesuaikan tinggi header
        width: double.infinity,
        color: const Color(0xFFFF7A21), // Warna oranye utama
        padding: const EdgeInsets.only(left: 25, top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Jika ada subtitle, tampilkan icon back (opsional, sesuaikan kebutuhan)
            if (subtitle == null)
              Row(
                children: [
                  const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Clipper tetap berada di sini agar menyatu dengan widget headernya
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getPath(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(0, size.height, 40, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
  
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    throw UnimplementedError();
  }
}