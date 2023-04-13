import 'package:flutter/material.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/notification.dart';
import 'package:postreal/presentation/widgets/no_notification_widget.dart';
import 'package:postreal/presentation/widgets/notification_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void dispose() {
    super.dispose();
    FirestoreMethods().markNotificationsAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: FirestoreMethods().notificationStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const NoNotificationWidget();
                }
                return Column(
                  children: [
                    TextButton(
                        onPressed: () async {
                          await FirestoreMethods().deleteAllNotifications();
                        },
                        child: const Text("Clear all")),
                    Expanded(
                      child: ListView.builder(
                          key: const PageStorageKey<String>('notificationPage'),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => NotificationTile(
                              notification: UserNotification.fromSnap(
                                  snapshot.data!.docs[index]))),
                    ),
                  ],
                );
              })),
    );
  }
}
