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
    return Badge(
      backgroundColor: Colors.red,
      alignment: AlignmentDirectional.centerEnd,
      // label: const Text("Rich"),
      label: const Icon(
        Icons.check,
        size: 12,
      ),
      isLabelVisible: isVerified,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(dpUrl),
      ),
    );
  }
}
