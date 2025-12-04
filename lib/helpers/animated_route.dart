import 'package:flutter/material.dart';

class AnimatedRoute extends PageRouteBuilder {
  final Widget page;
  AnimatedRoute({required this.page})
      : super(
    transitionDuration: const Duration(milliseconds: 700),
    reverseTransitionDuration: const Duration(milliseconds: 520),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {
      // Cinematic: scale + fade + slight slide
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      final fade = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
      final scale = Tween<double>(begin: 0.96, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutExpo));
      final offset = Tween<Offset>(
        begin: const Offset(0.0, 0.03),
        end: Offset.zero,
      ).animate(curved);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: offset,
          child: ScaleTransition(scale: scale, child: child),
        ),
      );
    },
  );
}
