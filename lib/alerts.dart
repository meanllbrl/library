import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'complex_button.dart';

class ComplexButtonStyle {
  final Color backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final TextStyle textStyle;
  ComplexButtonStyle(
      {this.backgroundColor = Colors.black,
      this.borderColor,
      this.borderRadius = 0,
       required this.textStyle});
}

class AlertHandler {
  //top icon dialog with 1 or two selection button
  static const double _padding = 20;
  static const double _avatarRadius = 45;

  //top icon method
  static void showTopIconDialog(
      {context,
      icon,
      required bool popScope,
      title = "",
      desc = "",
      but1 = "",
      but2 = "",
      iconBackgroundColor = Colors.red,
      onTapFirst,
      onTapSecond,
      required singleButton,
      onPressedInfo,
      headlineStyle,
      bodyStyle,
      required ComplexButtonStyle button1Style, ComplexButtonStyle? button2Style}) {
    //the body of the alert
    _contentBox(
        context,
        Widget child,
        title,
        desc,
        but1,
        but2,
        onTapFirst,
        onTapSecond,
        iconBackgroundColor,
        singleButton,
        bool textField,
        onPressedInfo,
        headlineStyle,
        bodyStyle,
        ComplexButtonStyle button1Style,ComplexButtonStyle? button2Style) {
      Size size = MediaQuery.of(context).size;
      return Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(_padding),
                  color: Colors.white,
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              padding: const EdgeInsets.only(
                  left: _padding,
                  top: _avatarRadius + _padding,
                  right: _padding,
                  bottom: _padding),
              margin: const EdgeInsets.only(top: _avatarRadius),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: headlineStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                                    SizedBox(height: 10,),

                  Text(
                    desc,
                    style: bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      ComplexButton(
                        height: 40,
                        width: size.width / 5,
                        radius: button1Style.borderRadius,
                        onPressed: onTapFirst,
                        backgroundColor: button1Style.backgroundColor,
                        borderColor: button1Style.borderColor,
                        border: button1Style.borderColor!= null,
                        
                        textStyle: button1Style.textStyle,
                        text: but1,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      !singleButton
                          ? ComplexButton(
                              height: 40,
                              width: size.width / 5,
                              radius: button2Style!=null ? button2Style.borderRadius : button1Style.borderRadius,
                              onPressed: onTapSecond,
                              backgroundColor: button2Style!=null ? button2Style.backgroundColor : button1Style.backgroundColor,
                              borderColor: button2Style!=null ? button2Style.borderColor : button1Style.borderColor,
                              textStyle: button2Style!=null ? button2Style.textStyle : button1Style.textStyle,
                        border: button2Style!=null ? button2Style.borderColor!= null : button1Style.borderColor!=null,

                              text: but2,
                            )
                          : Container(),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ), // bottom part
          Positioned(
            left: _padding,
            right: _padding,
            child: CircleAvatar(
                radius: _avatarRadius,
                backgroundColor: iconBackgroundColor,
                child: Center(child: child)),
          ), // top part
        ],
      );
    }

    //method which creates the dialog
    Dialog _alertDialog(
            context,
            child,
            title,
            desc,
            but1,
            but2,
            onTapFirst,
            onTapSecond,
            iconBackgroundColor,
            singleButton,
            textField,
            onPressedInfo,
            headlineStyle,
            bodyStyle,
            ComplexButtonStyle button1Style,
            ComplexButtonStyle? button2Style) =>
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_padding),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _contentBox(
              context,
              child,
              title,
              desc,
              but1,
              but2,
              onTapFirst,
              onTapSecond,
              iconBackgroundColor,
              singleButton,
              textField,
              onPressedInfo,
              headlineStyle,
              bodyStyle,
              button1Style,
              button2Style),
        );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
              onWillPop: () async => popScope,
              child: _alertDialog(
                  context,
                  icon,
                  title,
                  desc,
                  but1,
                  but2,
                  onTapFirst,
                  onTapSecond,
                  iconBackgroundColor,
                  singleButton,
                  false,
                  onPressedInfo,
                  headlineStyle,
                  bodyStyle,
                  button1Style,
                  button2Style ?? button1Style));
        });
  }

  static void simpleAlert(
    context, {
    required String title,
    required String desc,
    bool? onWillPop,
    AlertType? alertType,
    TextStyle? titleStyle,
    TextStyle? descStyle,
    List<DialogButton>? buttons,
    Color? backgroundColor,
    AnimationType? animationType,
    bool? isCloseButton,
    double? elevation,
  }) {
    Alert(
      context: context,
      title: title,
      desc: desc,
      style: AlertStyle(
        isCloseButton: isCloseButton ?? false,
        backgroundColor: backgroundColor ?? Colors.white,
        titleStyle: titleStyle ?? TextStyle(),
        isOverlayTapDismiss: false,
        alertElevation: elevation,
        animationType: animationType ?? AnimationType.grow,
        descStyle: descStyle ?? TextStyle(),
      ),
      onWillPopActive: onWillPop ?? false,
      type: alertType ?? AlertType.none,
      buttons: buttons,
    ).show();
  }
}
