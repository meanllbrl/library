import 'package:flutter/material.dart';

import 'helpers.dart';

///Text Field oluşumunu sağlayan sınıf

// ignore: must_be_immutable
class TextFieldShortCut extends StatelessWidget {
  final bool isPassword;
  final String? hintText, labelText;
  final IconData? icon;
  final Function onChanged;
  final int maxLines;
  final int minLines;
  final bool usePadding;
  final double padding;
  final TextEditingController? textEditingController;
  final TextStyle defaultTextStyles;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
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
          Text(
            labelText ?? "",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            onChanged: (value) {
              onChanged(value);
            },
            controller: textEditingController,
            //the text style
            style: TextStyle(),
            obscureText: isPassword,
            maxLines: maxLines,
            minLines: minLines,

            decoration: kTextFieldDecoration(
                preIcon: icon == null
                    ? null
                    : Icon(
                        icon,
                        color: Colors.white,
                        size: icon == null ? 0 : 25,
                      ),
                context: context,
                hintText: hintText,
                hintStyle: hintStyle,
                labelStyle: labelStyle
                //labelText: labelText,
                ),
          ),
        ],
      ),
    );
  }
}

InputDecoration kTextFieldDecoration(
        {context,
        hintText,
        labelText,
        preIcon,
        required hintStyle,
        required labelStyle}) =>
    InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: preIcon,
      //textStyles
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
      //todo daha şık bir textfield al..
    );
