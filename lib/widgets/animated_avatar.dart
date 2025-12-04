import 'package:flutter/material.dart';

class AnimatedAvatar extends StatelessWidget {
  final String heroTag;
  final Widget child;
  final double radius;
  final VoidCallback? onTap;

  const AnimatedAvatar({
    Key? key,
    required this.heroTag,
    required this.child,
    this.radius = 40,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cinematic glow with animated shimmer using AnimatedContainer
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
          // scale effect during hero flight
          return ScaleTransition(scale: animation.drive(Tween(begin: 0.92, end: 1.02).chain(CurveTween(curve: Curves.easeOutExpo))), child: toHeroContext.widget);
        },
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.18),
                  blurRadius: 22,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.deepPurple,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
