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

Color customCardColor(String openPalletLocation) {
  switch (openPalletLocation) {
    case "InBound":
      return AppColor().greyGoose;
    case "OutBound":
      return AppColor().lightMustard;
    case "Pallet":
    default:
      return AppColor().milkWhite;
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
