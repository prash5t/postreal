import 'package:flutter/material.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';

class UsernameWidget extends StatelessWidget {
  final bool isVerified;
  final String username;
  const UsernameWidget(
      {super.key, required this.isVerified, required this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: username,
          isBold: true,
        ),
        const SizedBox(width: 1),
        !isVerified
            ? const SizedBox()
            : const Badge(
                backgroundColor: Colors.tealAccent,
                label: Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 8,
                ),
              )
      ],
    );
  }
}
