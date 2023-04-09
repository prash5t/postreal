import 'package:flutter/material.dart';

// When user taps on display picture from Profile Screen,
// this widget is shown
class StalkDPWidget extends StatelessWidget {
  const StalkDPWidget({
    super.key,
    required this.profilePicUrl,
  });

  final String profilePicUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: ClipOval(
        child: Image.network(
          profilePicUrl,
          width: 400,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
