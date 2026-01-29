import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;
  const ItemCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Kode Alat :', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0822D),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Row(
                children: [
                  Container(width: 35, height: 35, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8))),
                  const SizedBox(width: 10),
                  Container(width: 35, height: 35, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8))),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}