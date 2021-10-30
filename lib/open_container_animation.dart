import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

//büyrek açılan widget
//KULLANIM:
class AnimatedWidget extends StatelessWidget {
  final Widget to;
  final Widget from;
  //elevations
  final double? closedElevation;
  final double? openedElevation;
  //colors
  final Color? openedColor;
  final Color? closedColor;
  final Color? middleColor;
  //duration
  final int? duration;
  //function
  final Function? onClosed;
  // ignore: prefer_const_constructors_in_immutables
  AnimatedWidget(
      {required this.to,
      required this.from,
      this.closedElevation,
      this.openedElevation,
      this.openedColor,
      this.closedColor,
      this.middleColor,
      this.duration,
      this.onClosed});
  @override
  Widget build(BuildContext context) {
    return AnimatedNavigator(
      closeBuilder: (BuildContext c, VoidCallback action) => from,
      openBuilder: (BuildContext c, VoidCallback action) => to,
      closedColor: closedColor,
      closedElevation: closedElevation,
      duration: duration,
      middleColor: middleColor,
      onClosed: onClosed,
      openedColor: openedColor,
      openedElevation: openedElevation,
    );
  }
}

//animasyonlu buton
// ignore: must_be_immutable
class AnimatedTopButton extends StatelessWidget {
  final Widget from;
  final Widget to;
  //elevations
  final double? closedElevation;
  final double? openedElevation;
  //colors
  final Color? openedColor;
  final Color? closedColor;
  final Color? middleColor;
  //duration
  final int? duration;
  //function
  final Function? onClosed;
  // ignore: prefer_const_constructors_in_immutables
  AnimatedTopButton(
      {required this.from,
      required this.to,
      this.closedElevation,
      this.openedElevation,
      this.openedColor,
      this.closedColor,
      this.middleColor,
      this.duration,
      this.onClosed});

  @override
  Widget build(BuildContext context) {
    return AnimatedNavigator(
      closeBuilder: (BuildContext c, VoidCallback action) => TextButton(
        style: circleButtonStyle,
        onPressed: () => action(),
        child: from,
      ),
      openBuilder: (BuildContext c, VoidCallback action) => to,
      closedColor: closedColor,
      closedElevation: closedElevation,
      duration: duration,
      middleColor: middleColor,
      onClosed: onClosed,
      openedColor: openedColor,
      openedElevation: openedElevation,
    );
  }

  ButtonStyle circleButtonStyle = ButtonStyle(
    overlayColor:
        MaterialStateProperty.all<Color>(Colors.deepPurpleAccent.shade200),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(360),
      ),
    ),
  );
}

//gereli class
class AnimatedNavigator extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final closeBuilder;
  // ignore: prefer_typing_uninitialized_variables
  final openBuilder;
  //elevations
  final double? closedElevation;
  final double? openedElevation;
  //colors
  final Color? openedColor;
  final Color? closedColor;
  final Color? middleColor;
  //duration
  final int? duration;
  //function
  final Function? onClosed;
  const AnimatedNavigator(
      {required this.closeBuilder,
      required this.openBuilder,
      this.closedElevation,
      this.openedElevation,
      this.openedColor,
      this.closedColor,
      this.middleColor,
      this.duration,
      this.onClosed});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: closedElevation ?? 0,
      openElevation: openedElevation ?? 0,
      closedColor: closedColor ?? Colors.transparent,
      openColor: openedColor ?? Colors.transparent,
      middleColor: middleColor ?? Colors.transparent,
      transitionDuration: Duration(milliseconds: duration ?? 500),
      closedBuilder: closeBuilder,
      openBuilder: openBuilder,
      tappable: true,
      onClosed: (val) {
        if (onClosed != null) onClosed!(val);
      },
    );
  }
}
