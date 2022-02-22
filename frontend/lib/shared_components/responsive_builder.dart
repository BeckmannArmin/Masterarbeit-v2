import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder(
      {Key key, this.mobileBuilder, this.tabletBuilder, this.desktopBuilder})
      : super(key: key);

  final Widget Function(BuildContext context, BoxConstraints constraints)
      mobileBuilder;

  final Widget Function(BuildContext context, BoxConstraints constraints)
      tabletBuilder;

  final Widget Function(BuildContext context, BoxConstraints constraints)
      desktopBuilder;

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) => 
  MediaQuery.of(context).size.width < 1250 &&
  MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1250;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 1250) {
          return desktopBuilder(context, constraints);
        } else if (constraints.maxWidth >= 650) {
          return tabletBuilder(context, constraints);
        } else {
          return mobileBuilder(context, constraints);
        }
      },
    );
  }
}