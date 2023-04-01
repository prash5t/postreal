import 'package:flutter/material.dart';

class DissmissWidget extends StatelessWidget {
  final String dissmissMsg;
  const DissmissWidget({super.key, required this.dissmissMsg});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(dissmissMsg),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Dismiss"))
        ],
      )),
    );
  }
}
