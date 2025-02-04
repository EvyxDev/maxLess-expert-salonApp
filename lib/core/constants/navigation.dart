import 'package:flutter/material.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/features/auth/presentation/pages/login.dart';

void navigateTo(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1100),
      reverseTransitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return const ZoomPageTransitionsBuilder().buildTransitions(
          MaterialPageRoute(builder: (context) => screen),
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    ),
  );
}

void navigateAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1300),
        // reverseTransitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => Widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      (route) {
        return false;
      },
    );

// void logOut(context) {
//   CacheNetwork.removeData(
//     key: 'token',
//   ).then((value) {
//     if (value) {
//       navigateAndFinish(context, Login());
//     }
//   });
// }
