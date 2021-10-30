import 'package:flutter/material.dart';

///Uygulama üzerinde kullanılan buton tasarımı

class ComplexButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ComplexButton(
      {required this.onPressed,
      this.text,
      this.backgroundColor = Colors.black,
      this.textSize = 12,
      this.textColor = Colors.white,
      this.margin = 0,
      this.height,
      this.width,
      this.radius,
      this.border = false,
      this.borderColor,
      this.textStyle,
      this.textWidget,
      this.feedbackColor,
      this.elevation,
      this.shadow});
  final Function onPressed;
  final String? text;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;
  final double? radius;
  final double margin;
  final double? height;
  final double? width;
  final bool border;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double? elevation;
  final Color? feedbackColor;
  final Widget? textWidget;
  final BoxShadow? shadow;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TextButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(elevation ?? 0),
        enableFeedback: true,
        overlayColor: MaterialStateProperty.all<Color>(
          feedbackColor ?? Colors.transparent,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Container(
        height: height ?? size.height / 20,
        width: width ?? size.width / 4,
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
          boxShadow: shadow != null ? [shadow!] : [],
          color: backgroundColor,
          border: Border(
            top: border
                ? BorderSide(
                    color: borderColor ?? Colors.transparent,
                  )
                : BorderSide(color: Colors.transparent),
          ),
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
        child: Center(
          // ignore: prefer_if_null_operators
          child: textWidget != null
              ? textWidget
              : Text(
                  text ?? "",
                  style: textStyle,
                ),
        ),
      ),
    );
  }
}
