import 'package:flutter/material.dart';

void dialogMsg(BuildContext context, String result) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(result),
      );
    },
  );
}
