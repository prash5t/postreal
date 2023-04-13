import 'package:flutter/material.dart';

import 'custom_text.dart';

class NoNotificationWidget extends StatelessWidget {
  const NoNotificationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.notifications_active,
            size: 80,
          ),
          SizedBox(height: 15),
          CustomText(text: "You currently have no notifications.")
        ],
      ),
    );
  }
}
