import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  final String senderId;
  final String senderUsername;
  final String senderProfilePic;
  final String notificationType;
  final DateTime timeStamp;
  final bool isRead;
  // final String msg;
  final String? postId;
  final String? postPicUrl;

  const UserNotification(
      {required this.senderId,
      required this.senderUsername,
      required this.senderProfilePic,
      required this.notificationType,
      required this.timeStamp,
      this.isRead = false,
      // required this.msg,
      this.postId,
      this.postPicUrl});

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'senderUsername': senderUsername,
        'senderProfilePic': senderProfilePic,
        'notificationType': notificationType,
        'timeStamp': timeStamp,
        'isRead': isRead,
        // 'msg': msg,
        'postId': postId,
        'postPicUrl': postPicUrl
      };

  static UserNotification fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = snapshot.data() as Map<String, dynamic>;
    return UserNotification(
        senderId: snap['senderId'],
        senderUsername: snap['senderUsername'],
        senderProfilePic: snap['senderProfilePic'],
        notificationType: snap['notificationType'],
        timeStamp: snap['timeStamp'].toDate(),
        isRead: snap['isRead'],
        // msg: snap['msg'],
        postId: snap['postId'],
        postPicUrl: snap['postPicUrl']);
  }
}
