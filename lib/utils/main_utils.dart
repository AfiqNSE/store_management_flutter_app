import 'package:flutter/material.dart';

AppBar customAppBar(
  String title,
) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        color: Color.fromRGBO(40, 40, 43, 1),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevation: 0.0,
    centerTitle: true,
    backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
  );
}

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

Color customCardColor(String text) {
  switch (text) {
    case "InBound":
      return const Color.fromRGBO(211, 211, 211, 1);
    case "OutBound":
      return const Color.fromRGBO(249, 205, 82, 1);
    case "Pallet":
    default:
      return const Color.fromRGBO(252, 252, 252, 1);
  }
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

extension StringExtension on String {
  String capitalize() =>
      length > 0 ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}" : "";

  String capitalizeOnly() =>
      length > 0 ? "${this[0].toUpperCase()}${substring(1)}" : "";

  String capitalizeWords() =>
      length > 0 ? split(' ').map((word) => word.capitalize()).join(' ') : "";

  String seperate() {
    var sb = StringBuffer();
    for (var rune in runes) {
      var char = String.fromCharCode(rune);
      if (char == char.toUpperCase()) {
        sb.write(' ');
        sb.write(char.toLowerCase());
      } else {
        sb.write(char);
      }
    }

    return sb.toString();
  }
}
