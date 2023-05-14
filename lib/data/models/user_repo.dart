import 'package:postreal/data/models/user.dart';

class UserRepo {
  final bool success;
  final String message;
  final User? user;

  UserRepo({required this.success, required this.message, this.user});
}
