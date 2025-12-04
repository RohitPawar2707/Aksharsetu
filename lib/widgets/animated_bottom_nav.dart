import 'package:flutter/material.dart';

class AnimatedBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AnimatedBottomNav({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  State<AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<AnimatedBottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0C0C1F),
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white38,
      items: [
        _buildItem(Icons.home_rounded, "Home", 0),
        _buildItem(Icons.person_rounded, "Profile", 1),
        _buildItem(Icons.school_rounded, "Learn", 2),
      ],
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  BottomNavigationBarItem _buildItem(IconData icon, String label, int index) {
    final bool active = widget.currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        padding: EdgeInsets.all(active ? 6 : 0),
        decoration: BoxDecoration(
          color: active ? Colors.deepPurpleAccent.withOpacity(0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: active ? 24 : 22),
      ),
      label: label,
    );
  }
}
