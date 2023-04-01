import 'package:flutter/material.dart';
import 'package:postreal/constants/presentation_constants.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileLayout;
  final Widget webLayout;

  const ResponsiveLayout({
    Key? key,
    required this.mobileLayout,
    required this.webLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webLayout;
      }
      return widget.mobileLayout;
    });
  }
}
