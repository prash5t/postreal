import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';
import 'package:postreal/presentation/widgets/user_dp.dart';
import 'package:postreal/presentation/widgets/username_widget.dart';
import 'package:postreal/utils/stripe/make_stripe_payment.dart';

class SuperUserWidget extends StatefulWidget {
  final bool isVerified;
  final String username;
  final String dpUrl;
  const SuperUserWidget(
      {super.key,
      required this.isVerified,
      required this.username,
      required this.dpUrl});

  @override
  State<SuperUserWidget> createState() => _SuperUserWidgetState();
}

class _SuperUserWidgetState extends State<SuperUserWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isVerified
          ? null
          : () {
              /// fyi: using stripe
              makePayment();
            },
      child: ListTile(
        tileColor: widget.isVerified ? null : Colors.teal,
        leading: UserDP(dpUrl: widget.dpUrl, isVerified: widget.isVerified),
        title: UsernameWidget(
            isVerified: widget.isVerified, username: widget.username),
        subtitle: CustomText(
            text: widget.isVerified
                ? "Super User"
                : "Become a Super User at just \$1.99."),
        trailing: widget.isVerified ? null : const Icon(CupertinoIcons.forward),
      ),
    );
  }
}
