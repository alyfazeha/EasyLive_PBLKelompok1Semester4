import 'package:flutter/material.dart';
import 'dart:async';

class HeaderSlider extends StatefulWidget {
  const HeaderSlider({super.key});

  @override
  State<HeaderSlider> createState() => _HeaderSliderState();
}

class _HeaderSliderState extends State<HeaderSlider> {
  // Ditambahkan viewportFraction agar slide berikutnya sedikit terlihat
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

<<<<<<< Updated upstream
  final List<String> images = [
<<<<<<< HEAD
    "assets/images/kos1.jpg",
    "assets/images/kos2.jpg",
    "assets/images/kos3.jpg",
=======
    "images/kos1.jpg",
    "images/kos2.jpg",
    "images/kos3.jpg",
=======
  // Data dummy sederhana (bisa diganti dari model nanti)
  final List<Map<String, String>> sliderData = [
    {"image": "assets/images/kos1.jpg", "title": "Kost Putri Melati"},
    {"image": "assets/images/kos2.jpg", "title": "Kost Eksklusif Malang"},
    {"image": "assets/images/kos3.jpg", "title": "Kost Putra Dekat Polinema"},
>>>>>>> Stashed changes
>>>>>>> ailsa
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % sliderData.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220, // Tinggi area slider
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: sliderData.length,
            itemBuilder: (context, index) {
              return _buildSliderItem(index);
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            sliderData.length,
            (index) => DotIndicator(active: _currentPage == index),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderItem(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        // Efek zoom sedikit pada kartu yang aktif
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 200,
            width: Curves.easeInOut.transform(value) * 400,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFEAC793), // Warna Kuning EasyLive
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Gambar
              Image.asset(
                sliderData[index]["image"]!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              // Overlay Gelap agar teks terbaca
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Teks di atas gambar
              Positioned(
                bottom: 15,
                left: 15,
                child: Text(
                  sliderData[index]["title"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool active;
  const DotIndicator({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 20 : 8, // Dot memanjang kalau aktif
      height: 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF5E0006) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
