import 'package:flutter/material.dart';
import 'package:postreal/data/models/notification.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';
import 'package:postreal/utils/date_to_string.dart';
import 'package:postreal/utils/notification_msg.dart';

class NotificationTile extends StatelessWidget {
  final UserNotification notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage(notification.senderProfilePic)),
      title: CustomText(
        text: notificationMsg(notification),
        size: 14,
        isBold: !notification.isRead,
      ),
      subtitle: Row(
        children: [
          CustomText(
            text: dateToString(notification.timeStamp),
            size: 12,
          ),
          const SizedBox(width: 10),
          Badge(
            label: const Text("New"),
            smallSize: 8,
            isLabelVisible: !notification.isRead,
          )
        ],
      ),
      trailing: notification.notificationType == 'follow'
          ? null
          : Image.network(notification.postPicUrl!),
    );
  }
}
