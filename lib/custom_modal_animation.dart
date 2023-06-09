import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class CustomModalAnimation extends StatefulWidget {
  final Widget child;

  CustomModalAnimation({required this.child});

  @override
  _CustomModalAnimationState createState() => _CustomModalAnimationState();
}

class _CustomModalAnimationState extends State<CustomModalAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Set the animation duration
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Set the animation curve
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0.0, (1 - _animation.value) * 300), // Set the vertical translation distance
          child: Opacity(
            opacity: _animation.value, // Set the opacity
            child: widget.child,
          ),
        );
      },
    );
  }
}
