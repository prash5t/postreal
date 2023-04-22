import 'package:flutter/material.dart';

void scrollToTop(ScrollController controller) {
  controller.animateTo(
    0,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeOut,
  );
}
