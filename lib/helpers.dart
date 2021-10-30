//sayfa geçişlerini sağlayacak sınıf
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NavigationHelper {
  //navgation normally with animation
  static void goPage(context,
      {required Widget path, PageTransitionType? transitionType}) {
    Navigator.push(
        context,
        PageTransition(
            type: transitionType ?? PageTransitionType.fade, child: path));
  }

  //go with name
  static void goPageNamed(context, {required String path}) {
    Navigator.pushNamed(context, path);
  }

  //navgation replacement with animation
  static void goPageReplace(context,
      {required Widget path, PageTransitionType? transitionType}) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: transitionType ?? PageTransitionType.fade, child: path));
  }

  //go named and replace
  static void goPageReplaceNamed(context, {required String path}) {
    Navigator.pushReplacementNamed(context, path);
  }

  //go and close
  static void goAndRemove(context,
      {required Widget path, PageTransitionType? transitionType}) {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            type: transitionType ?? PageTransitionType.fade, child: path),
        (route) => false);
  }

  //go and close named
  static void goAndRemoveNamed(context, {required String path}) {
    Navigator.pushNamedAndRemoveUntil(context, path, (route) => false);
  }
}

//in app message
void inAppMessage(context,
    {EdgeInsets? padding,
    Duration? animationDuration,
    Color? backgroundColor,
    Color? borderColor,
    Gradient? backgroundGradient,
    double? barBlur,
    double? borderWidth,
    BorderRadius? radius,
    BoxShadow? boxShadow,
    Widget? widget,
    Widget? button,
    required String title,
    required TextStyle titleStyle,
    required String message,
    required TextStyle messageStyle,
    FlushbarDismissDirection? dismissDirection,
    Curve? animationCurve,
    FlushbarPosition? position,
    bool? dismissible,
    Function? onTap}) {
  // ignore: avoid_single_cascade_in_expression_statements
  Flushbar(
    padding: padding ?? const EdgeInsets.all(8),
    animationDuration: animationDuration ?? const Duration(milliseconds: 400),
    backgroundColor: backgroundColor ?? Colors.deepOrangeAccent,
    backgroundGradient: backgroundGradient,
    barBlur: barBlur ?? 0,
    boxShadows: [
      boxShadow ??
          BoxShadow(
            color: messageStyle.color ?? Colors.black,
            offset: const Offset(3, 3),
            blurRadius: 3,
          )
    ],
    dismissDirection: dismissDirection ?? FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: animationCurve ?? Curves.easeIn,
    flushbarPosition: position ?? FlushbarPosition.TOP,
    borderColor: borderColor,
    borderRadius: radius,
    borderWidth: borderWidth ?? 1,
    flushbarStyle: FlushbarStyle.FLOATING,
    icon: widget,
    isDismissible: dismissible ?? true,
    mainButton: button,
    title: title,
    titleColor: titleStyle.color,
    titleSize: titleStyle.fontSize,
    message: message,
    messageColor: messageStyle.color,
    messageSize: messageStyle.fontSize,
    onTap: (tap) {
      if (onTap != null) {
        onTap(tap);
      }
    },
  )..show(context);
}
