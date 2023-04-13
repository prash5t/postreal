import 'package:postreal/data/models/notification.dart';

String notificationMsg(UserNotification notification) {
  switch (notification.notificationType) {
    case 'like':
      return '${notification.senderUsername} liked your post.';
    case 'comment':
      return '${notification.senderUsername} commented on your post.';
    case 'follow':
      return '${notification.senderUsername} followed you.';
    default:
      return notification.notificationType;
  }
}
