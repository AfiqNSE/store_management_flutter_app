import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';

AppBar customAppBar(
  String title,
) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevation: 0.0,
    centerTitle: true,
    backgroundColor: AppColor().milkWhite,
  );
}

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

Color customCardColor(String palletLocation) {
  switch (palletLocation) {
    case "inbound":
      return AppColor().greyGoose;
    case "outbound":
      return AppColor().lightMustard;
    case "Pallet":
    default:
      return AppColor().milkWhite;
  }
}

Widget customEmptyValue = const Padding(
  padding: EdgeInsets.only(right: 3),
  child: Text('N/A'),
);

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
