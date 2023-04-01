import 'package:flutter/material.dart';
import 'package:postreal/data/auth_methods.dart';
import 'package:postreal/data/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethod = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
