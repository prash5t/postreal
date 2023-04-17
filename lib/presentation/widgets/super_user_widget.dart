import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';
import 'package:postreal/presentation/widgets/user_dp.dart';
import 'package:postreal/presentation/widgets/username_widget.dart';
import 'package:postreal/utils/pay_with_khalti.dart';

class SuperUserWidget extends StatelessWidget {
  final bool isVerified;
  final String username;
  final String dpUrl;
  const SuperUserWidget(
      {super.key,
      required this.isVerified,
      required this.username,
      required this.dpUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isVerified
          ? null
          : () {
              payWithKhalti();
            },
      child: ListTile(
        tileColor: isVerified ? null : Colors.teal,
        leading: UserDP(dpUrl: dpUrl, isVerified: isVerified),
        title: UsernameWidget(isVerified: isVerified, username: username),
        subtitle: CustomText(
            text: isVerified
                ? "Super User"
                : "Become a Super User at just Rs 1."),
        trailing: isVerified ? null : const Icon(CupertinoIcons.forward),
      ),
    );
  }
}
