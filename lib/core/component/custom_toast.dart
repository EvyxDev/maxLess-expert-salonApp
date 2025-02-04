
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showToast(
  BuildContext context, {
  required String message,
  required ToastStates state,
}) {
  OverlayEntry toast = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 30.h,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: choosePopUpColor(state),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(toast);

  Future.delayed(const Duration(seconds: 3), () {
    toast.remove();
  });
}

enum ToastStates {
  success,
  error,
  warning,
}

Color choosePopUpColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}
