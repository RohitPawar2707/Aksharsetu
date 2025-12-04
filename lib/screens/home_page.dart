import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> recentImages = [];
  int currentIndex = 0;

  late AnimationController _bgController;
  late AnimationController _titleController;
  late AnimationController _shimmerController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.82)
      ..addListener(() => setState(() {}));

    _bgController =
    AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat(reverse: true);

    _titleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: 0, max: 1, period: const Duration(seconds: 2));

    // ⭐ AUTO SCROLL FOR RECENT IMAGES
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      final list = _displayList();
      if (list.isEmpty) return;

      int nextPage = currentIndex + 1;
      if (nextPage >= list.length) nextPage = 0;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _titleController.dispose();
    _shimmerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<String> _displayList() {
    return recentImages.isEmpty
        ? ["placeholder1", "placeholder2", "placeholder3"]
        : recentImages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1133),

      body: Stack(
        children: [
          _buildBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),

                  const SizedBox(height: 20),
                  _buildAnimatedTitle(),

                  const SizedBox(height: 22),
                  _buildMainCard(),

                  const SizedBox(height: 28),
                  const Text(
                    "Recently Scanned Images",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 18),
                  _buildCarousel(), // ⭐ Bigger height + auto scroll

                  const SizedBox(height: 16),
                  _buildDots(),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ---------------- BACKGROUND -------------------
  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        double t = _bgController.value;
        return Transform.translate(
          offset: Offset((t - 0.5) * 40, 0),
          child: child,
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E1133), Color(0xFF15173A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER -------------------
  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 38, // ⭐ Bigger logo
          backgroundColor: Colors.white10,
          child: ClipOval(child: Image.asset("assets/logo.png")),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aksharsetu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34, // ⭐ Bigger title
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Transliteration Bridge",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- ANIMATED TITLE -------------------
  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, child) {
        double t = Curves.easeOut.transform(_titleController.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
              offset: Offset(0, 25 * (1 - t)), child: child),
        );
      },
      child: const Text(
        "Ready to transliterate!",
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
      ),
    );
  }

  // ---------------- MAIN CARD -------------------
  Widget _buildMainCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 260,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/akshar_logo.png",
                  height: 130,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.translate,
                      size: 110, color: Colors.white70)),
              const SizedBox(height: 16),
              const Text(
                "Extract · Convert · Understand",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- CAROUSEL (BIGGER + AUTO SCROLL) -------------------
  Widget _buildCarousel() {
    final list = _displayList();

    return SizedBox(
      height: 300, // ⭐ Increase height more
      child: PageView.builder(
        controller: _pageController,
        itemCount: list.length,
        onPageChanged: (i) => setState(() => currentIndex = i),
        itemBuilder: (ctx, i) {
          final delta = (i - (_pageController.page ?? 0));
          final scale = (1 - delta.abs() * 0.1).clamp(0.85, 1.0);

          return Transform.scale(
            scale: scale,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: recentImages.isEmpty
                        ? _buildShimmer()
                        : Image.file(File(list[i]), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Text(
      "No Images scanned yet",
      style: TextStyle(color: Colors.white70.withOpacity(.9), fontSize: 18),
    );
  }

  // ---------------- DOTS -------------------
  Widget _buildDots() {
    final total = _displayList().length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        bool active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: active ? 22 : 7,
          height: active ? 9 : 7,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE84393) : Colors.white30,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  // ---------------- BOTTOM NAVIGATION -------------------
  Widget _buildBottomNavBar() {
    return Container(
      height: 90,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1E45),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navBtn(Icons.home_rounded, "Home",
                  () => Navigator.pushNamed(context, "/home")),

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/camera"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6FB1FC), Color(0xFF0052D4)],
                    ),
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(height: 4),
                const Text("Scan",
                    style:
                    TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),

          _navBtn(Icons.person_rounded, "Profile",
                  () => Navigator.pushNamed(context, "/profile")),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, String label, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 26),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
