import 'package:flutter/material.dart';

class BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;

  const BounceButton({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.90, // how much it "blows"
  });

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: widget.scale, // min scale
      upperBound: 1.0, // normal size
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.reverse(); // shrink
  }

  void _tapUp(TapUpDetails details) {
    _controller.forward(); // grow back
    widget.onTap();        // trigger main action
  }

  void _tapCancel() {
    _controller.forward(); // reset
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTapCancel: _tapCancel,
      child: ScaleTransition(
        scale: _controller,
        child: widget.child,
      ),
    );
  }
}
