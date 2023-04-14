import 'package:flutter/material.dart';
import 'package:postreal/data/auth_methods.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/notification.dart';
import 'package:postreal/main.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';
import 'package:postreal/presentation/widgets/post_bottom_sheet.dart';
import 'package:postreal/utils/date_to_string.dart';
import 'package:postreal/utils/notification_msg.dart';
import 'package:postreal/utils/take_to_profile.dart';

class NotificationTile extends StatelessWidget {
  final UserNotification notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (notification.notificationType == "follow") {
          navigateToProfile(notification.senderId);
        } else {
          FirestoreMethods().getPostData(notification.postId!).then((post) {
            postModalBottomSheet(
                context: navKey.currentContext!,
                post: post,
                currentUserId: AuthMethods().auth.currentUser!.uid);
          });
        }
      },
      child: ListTile(
        leading: GestureDetector(
          onTap: () => navigateToProfile(notification.senderId),
          child: CircleAvatar(
              backgroundImage: NetworkImage(notification.senderProfilePic)),
        ),
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
      ),
    );
  }
}
