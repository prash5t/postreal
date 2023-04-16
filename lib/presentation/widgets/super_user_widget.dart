import 'package:flutter/material.dart';

class SuperUserWidget extends StatelessWidget {
  final bool isVerified;
  const SuperUserWidget({super.key, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: isVerified ? null : () {},
          child: Text(isVerified
              ? "Super User"
              : "Become a super user at just 1 Paisa")),
    );
  }
}
