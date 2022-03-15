import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BottomBarHelper extends StatelessWidget {
  const BottomBarHelper(
      {Key? key,
      this.willPop = false,
      required this.screens,
      this.tabController,
      this.items,
      this.useSafeArea = true,
      required this.backgroundColor,
      this.hideNavBarWhenKeyboardShows = true,
      this.navbarPadding,
      this.shadowColor = Colors.black38,
      required this.colorBehindNavbar,
      this.navBarHeight = 53,
      this.itemAnimationDuration = const Duration(milliseconds: 350),
      this.itemAnimationCurve = Curves.easeIn,
      this.screenAnimationDuration = const Duration(milliseconds: 350),
      this.screenAnimationCurve = Curves.easeIn,
      required this.navBarStyle,
      this.onItemSelected})
      : super(key: key);
  final bool willPop;
  final List<Widget> screens;
  final PersistentTabController? tabController;
  final List<PersistentBottomNavBarItem>? items;
  final bool useSafeArea;
  final Color backgroundColor;
  final bool hideNavBarWhenKeyboardShows;
  final NavBarPadding? navbarPadding;
  final Color shadowColor;
  final Color colorBehindNavbar;
  final double navBarHeight;
  final Duration itemAnimationDuration;
  final Curve itemAnimationCurve;
  final Duration screenAnimationDuration;
  final Curve screenAnimationCurve;
  final NavBarStyle navBarStyle;
  final Function(int)? onItemSelected;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => willPop,
        child: PersistentTabView(
          context,
          screens: screens,
          controller: tabController,
          items: items,
          onItemSelected: onItemSelected ?? null,
          confineInSafeArea: useSafeArea,
          backgroundColor: backgroundColor,
          hideNavigationBarWhenKeyboardShows: hideNavBarWhenKeyboardShows,
          padding: navbarPadding ?? NavBarPadding.all(0),
          decoration: NavBarDecoration(
            boxShadow: [
              BoxShadow(
                color: shadowColor,
              )
            ],
            colorBehindNavBar: colorBehindNavbar,
          ),
          navBarHeight: navBarHeight,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: itemAnimationDuration,
            curve: itemAnimationCurve,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: screenAnimationCurve,
            duration: screenAnimationDuration,
          ),
          navBarStyle: navBarStyle,
        ));
  }
}
