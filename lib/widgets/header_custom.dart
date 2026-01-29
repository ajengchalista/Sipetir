import 'package:flutter/material.dart';

class HeaderCustom extends StatelessWidget {
  final String title;
  final String? subtitle;

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
        height: 170,
        width: double.infinity,
        color: const Color(0xFFFF7A21),
        padding: const EdgeInsets.only(left: 25, top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// CLIPPER WAJIB ADA DI SINI
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(0, size.height, 40, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
