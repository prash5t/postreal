import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String commentatorProfilePicUrl;
  final bool isVerified;
  final String commentatorUsername;
  final String commentatorId;
  final DateTime dateCommented;
  final String text;

  const Comment({
    required this.text,
    required this.commentId,
    required this.commentatorProfilePicUrl,
    required this.isVerified,
    required this.commentatorUsername,
    required this.commentatorId,
    required this.dateCommented,
  });

  Map<String, dynamic> toJson() => {
        "text": text,
        "commentId": commentId,
        "commentatorProfilePicUrl": commentatorProfilePicUrl,
        "isVerified": isVerified,
        "commentatorUsername": commentatorUsername,
        "commentatorId": commentatorId,
        "dateCommented": dateCommented
      };
  static Comment fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = snapshot.data() as Map<String, dynamic>;
    return Comment(
        text: snap['text'],
        commentId: snap['commentId'],
        commentatorProfilePicUrl: snap['commentatorProfilePicUrl'],
        isVerified: snap['isVerified'] ?? false,
        commentatorUsername: snap['commentatorUsername'],
        commentatorId: snap['commentatorId'],
        dateCommented: snap['dateCommented'].toDate());
  }
}
