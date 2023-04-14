import 'package:flutter/material.dart';
import 'package:postreal/main.dart';
import '../presentation/shared_layout/profile_screen.dart';

// this method can be used in multiple places where user wants to visit someone's profile
void navigateToProfile(String profileId) {
  Navigator.of(navKey.currentContext!).push(
    MaterialPageRoute(
        builder: (context) => ProfileScreen(uIdOfProfileOwner: profileId)),
  );
}
