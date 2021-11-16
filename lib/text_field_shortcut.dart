import 'package:flutter/material.dart';

///Text Field oluşumunu sağlayan sınıf

// ignore: must_be_immutable
class TextFieldShortCut extends StatelessWidget {
  final bool isPassword;
  final String? hintText, labelText;
  final dynamic? icon;
  final Function onChanged;
  final int maxLines;
  final int minLines;
  final bool usePadding;
  final double padding;
  final TextEditingController? textEditingController;
  final TextStyle defaultTextStyles;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final bool isLabelOnTop;
  final bool isSuffix;
  // ignore: use_key_in_widget_constructors
  TextFieldShortCut({
    this.hintText = "",
    this.maxLines = 1,
    this.minLines = 1,
    required this.onChanged,
    this.icon,
    this.labelText = "",
    this.usePadding = true,
    this.isPassword = false,
    this.padding = 40,
    this.textEditingController,
    required this.defaultTextStyles,
    this.hintStyle,
    this.labelStyle,
    this.isLabelOnTop = true,
    this.isSuffix = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: usePadding
          ? EdgeInsets.symmetric(
              horizontal: padding,
              vertical: 5,
            )
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLabelOnTop
              ? Column(
                  children: [
                    Text(
                      labelText ?? "",
                      style: labelStyle ?? Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )
              : Container(),
          TextField(
            onChanged: (value) {
              onChanged(value);
            },
            controller: textEditingController,
            //the text style
            style: defaultTextStyles,
            obscureText: isPassword,
            maxLines: maxLines,
            minLines: minLines,

            decoration: kTextFieldDecoration(
              preIcon: icon == null || isSuffix
                  ? null
                  : Icon(
                      icon,
                      color: Colors.white,
                      size: icon == null ? 0 : 25,
                    ),
              suffixIcon: isSuffix
                  ? icon
                  : null,
              context: context,
              hintText: hintText,
              hintStyle: hintStyle,
              labelStyle: labelStyle,
              labelText: isLabelOnTop ? null : labelText,
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration kTextFieldDecoration({
  context,
  hintText,
  labelText,
  preIcon,
  suffixIcon,
  required hintStyle,
  required labelStyle,
}) =>
    InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: preIcon,
      //textStyles
      suffixIcon: suffixIcon,
      hintStyle: hintStyle,

      labelStyle: labelStyle,
      focusColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      enabledBorder: const OutlineInputBorder(
        gapPadding: 0,
        borderSide: BorderSide(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        gapPadding: 0,
        borderSide: BorderSide(color: Colors.lightGreen, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
