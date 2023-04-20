import 'package:flutter/material.dart';

class UserDP extends StatelessWidget {
  final String dpUrl;
  final bool isVerified;
  final double radius;
  const UserDP(
      {super.key,
      required this.dpUrl,
      required this.isVerified,
      this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: !isVerified
            ? null
            : BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3.0,
                ),
                shape: BoxShape.circle,
              ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(dpUrl),
        ),
      ),
    );
  }
}
