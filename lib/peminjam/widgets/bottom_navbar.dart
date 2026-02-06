import 'package:flutter/material.dart';

class PeminjamNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int jumlahKeranjang;

  const PeminjamNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.jumlahKeranjang,
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah halaman keranjang (index 4) sedang aktif
    bool isCartActive = currentIndex == 4;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        BottomNavigationBar(
          // Jika index 4, kita set -1 agar tidak ada item navbar bawah yang terlihat terpilih
          // Atau tetap gunakan logika kamu tapi pastikan label tetap konsisten
          currentIndex: currentIndex > 3 ? 0 : currentIndex, 
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: isCartActive ? Colors.grey : const Color(0xFFFF7A21),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: !isCartActive, // Sembunyikan label pilih jika di keranjang
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Alat'),
            // Spacer untuk memberi ruang pada tombol keranjang di tengah
            BottomNavigationBarItem(icon: SizedBox(width: 40), label: ''), 
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Kembali'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Pinjam'),
          ],
        ),
        // Tombol Keranjang Floating
        Positioned(
          top: -30,
          child: GestureDetector(
            onTap: () => onTap(2),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    // Beri warna lebih pekat jika sedang aktif/terpilih
                    color: isCartActive ? const Color(0xFFFF7A21) : const Color(0xFFFFE5D1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFF7A21), 
                      width: 2
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF7A21).withOpacity(0.3),
                        blurRadius: isCartActive ? 15 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shopping_basket_outlined,
                    size: 35,
                    // Warna icon kontras jika aktif
                    color: isCartActive ? Colors.white : const Color(0xFFFF7A21),
                  ),
                ),
                // Badge Angka
                if (jumlahKeranjang > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      child: Text(
                        '$jumlahKeranjang',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}