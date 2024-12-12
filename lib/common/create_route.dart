import 'package:flutter/material.dart';

Route createRoute(Widget screen, {double dx = 1, double dy = 0}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        /// default(1,0) mimics swipe right to left, (-1,0) is left to right
        /// (0,1) is up and (0,-1) is down
        final begin = Offset(dx, dy);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      });
}
