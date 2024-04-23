import 'package:flutter/material.dart';

Widget appBarTitle(
  String title,
) {
  return Text(title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ));
}

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  final bool toRight;
  SlideRoute({
    required this.page,
    required this.toRight,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin =
                toRight ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
            const end = Offset.zero;

            var curveTween = CurveTween(curve: Curves.easeInOutQuart);
            var tween = Tween(begin: begin, end: end).chain(curveTween);

            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        );
}
