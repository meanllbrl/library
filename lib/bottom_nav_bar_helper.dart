// import 'package:flutter/material.dart';

// class BottomBarHelper extends StatefulWidget {
//   const BottomBarHelper(
//       {Key? key,
//       this.willPop = false,
//       required this.screens,
//       this.items,
//       this.useSafeArea = true,
//       required this.backgroundColor,
//       this.hideNavBarWhenKeyboardShows = true,
//       this.navbarPadding,
//       this.shadowColor = Colors.black38,
//       required this.colorBehindNavbar,
//       this.navBarHeight = 53,
//       this.itemAnimationDuration = const Duration(milliseconds: 350),
//       this.itemAnimationCurve = Curves.easeIn,
//       this.screenAnimationDuration = const Duration(milliseconds: 350),
//       this.screenAnimationCurve = Curves.easeIn,
//       required this.navBarStyle,
//       this.initialIndex = 0,
//       this.onItemSelected})
//       : super(key: key);
//   final bool willPop;
//   final List<Widget> screens;
//   final List<PersistentBottomNavBarItem>? items;
//   final bool useSafeArea;
//   final Color backgroundColor;
//   final bool hideNavBarWhenKeyboardShows;
//   final NavBarPadding? navbarPadding;
//   final Color shadowColor;
//   final Color colorBehindNavbar;
//   final double navBarHeight;
//   final Duration itemAnimationDuration;
//   final Curve itemAnimationCurve;
//   final Duration screenAnimationDuration;
//   final Curve screenAnimationCurve;
//   final NavBarStyle navBarStyle;
//   final Function(int)? onItemSelected;
//   final int initialIndex;

//   @override
//   State<BottomBarHelper> createState() => _BottomBarHelperState();
// }

// class _BottomBarHelperState extends State<BottomBarHelper> {
//   late PersistentTabController _persistentTabController;
//   @override
//   void initState() {
//     super.initState();
//     _persistentTabController =
//         PersistentTabController(initialIndex: widget.initialIndex);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _persistentTabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async => widget.willPop,
//         child: PersistentTabView(
//           context,
//           screens: widget.screens,
//           controller: _persistentTabController,
//           items: widget.items,
//           onItemSelected: (int index) {
//             if (widget.onItemSelected != null) {
//               widget.onItemSelected!(index);
//             }
//             _persistentTabController.jumpToTab(index);
//           },
//           confineInSafeArea: widget.useSafeArea,
//           backgroundColor: widget.backgroundColor,
//           hideNavigationBarWhenKeyboardShows:
//               widget.hideNavBarWhenKeyboardShows,
//           padding: widget.navbarPadding ?? NavBarPadding.all(0),
//           decoration: NavBarDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: widget.shadowColor,
//               )
//             ],
//             colorBehindNavBar: widget.colorBehindNavbar,
//           ),
//           navBarHeight: widget.navBarHeight,
//           itemAnimationProperties: ItemAnimationProperties(
//             // Navigation Bar's items animation properties.
//             duration: widget.itemAnimationDuration,
//             curve: widget.itemAnimationCurve,
//           ),
//           screenTransitionAnimation: ScreenTransitionAnimation(
//             // Screen transition animation on change of selected tab.
//             animateTabTransition: true,
//             curve: widget.screenAnimationCurve,
//             duration: widget.screenAnimationDuration,
//           ),
//           navBarStyle: widget.navBarStyle,
//         ));
//   }
// }
