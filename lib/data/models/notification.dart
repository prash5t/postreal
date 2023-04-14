import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  final String notificationId;
  final String senderId;
  final String senderUsername;
  final String senderProfilePic;
  final bool isVerified;
  final String notificationType;
  final DateTime timeStamp;
  final bool isRead;
  final String? postId;
  final String? postPicUrl;

  const UserNotification(
      {required this.notificationId,
      required this.senderId,
      required this.senderUsername,
      required this.senderProfilePic,
      required this.isVerified,
      required this.notificationType,
      required this.timeStamp,
      this.isRead = false,
      this.postId,
      this.postPicUrl});

  Map<String, dynamic> toJson() => {
        'notificationId': notificationId,
        'senderId': senderId,
        'senderUsername': senderUsername,
        'senderProfilePic': senderProfilePic,
        'isVerified': isVerified,
        'notificationType': notificationType,
        'timeStamp': timeStamp,
        'isRead': isRead,
        'postId': postId,
        'postPicUrl': postPicUrl
      };

  static UserNotification fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = snapshot.data() as Map<String, dynamic>;
    return UserNotification(
        notificationId: snap['notificationId'],
        senderId: snap['senderId'],
        senderUsername: snap['senderUsername'],
        senderProfilePic: snap['senderProfilePic'],
        isVerified: snap['isVerified'] ?? false,
        notificationType: snap['notificationType'],
        timeStamp: snap['timeStamp'].toDate(),
        isRead: snap['isRead'],
        postId: snap['postId'],
        postPicUrl: snap['postPicUrl']);
  }
}
