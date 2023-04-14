import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/constants/presentation_constants.dart';
import 'package:postreal/constants/routes.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/user.dart';
import 'package:postreal/main.dart';
import 'package:postreal/presentation/shared_layout/feed_screen.dart';
import 'package:postreal/presentation/shared_layout/notification_screen.dart';
import 'package:postreal/presentation/shared_layout/profile_screen.dart';
import 'package:postreal/presentation/shared_layout/search_screen.dart';
import 'package:postreal/presentation/widgets/bool_bottom_sheet.dart';
import 'package:postreal/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navAt = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _addData();
  }

  void _addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void _onPageChanged(int page) {
    setState(() {
      _navAt = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<AuthBloc>(context).getCurrentUser;

    return WillPopScope(
      onWillPop: () async {
        bool? shouldExit = await booleanBottomSheet(
            context: navKey.currentContext!,
            titleText: closeAppTitle,
            boolTrueText: "Close PostReal");

        try {
          return shouldExit!;
        } catch (e) {
          debugPrint(e.toString());
          return false;
        }
      },
      child: Scaffold(
        floatingActionButton: _navAt == 3
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(
                      navKey.currentContext!, AppRoutes.addPostScreen);
                },
                label: const Text("Post real"),
                icon: const Icon(Icons.add_a_photo),
              )
            : null,
        bottomNavigationBar: CupertinoTabBar(
            currentIndex: _navAt,
            onTap: _navigationTapped,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home)),
              const BottomNavigationBarItem(icon: Icon(Icons.search)),
              BottomNavigationBarItem(
                  icon: StreamBuilder(
                      stream: FirestoreMethods().notificationStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        // querying to get the length of notifications which are not read.
                        final notificationCount = snapshot.data!.docs
                            .where((doc) => doc.data()['isRead'] == false)
                            .toList()
                            .length;
                        return Badge(
                            label: Text(notificationCount.toString()),
                            isLabelVisible: notificationCount > 0,
                            child: const Icon(Icons.notifications));
                      })),
              const BottomNavigationBarItem(icon: Icon(Icons.person)),
            ]),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            const FeedScreen(),
            const SearchScreen(),
            const NotificationScreen(),
            ProfileScreen(uIdOfProfileOwner: user.uid),
          ],
        ),
      ),
    );
  }
}
