import 'package:flutter/material.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';

// this bottom sheet to be used in places like:
// onWillPop property, post delete feature
// takes title text, yes/true button text
Future<bool?> booleanBottomSheet(
    {required BuildContext context,
    required String titleText,
    required String boolTrueText}) {
  return showModalBottomSheet<bool>(
    elevation: 1,
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(color: Colors.grey, width: 48, height: 4)),
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: CustomText(text: "Are you sure?", size: 16, isBold: true),
            ),
            const SizedBox(height: 8),
            CustomText(text: titleText, size: 12),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    boolTrueText,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: InkWell(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 48,
                      child: const CustomText(text: "Cancel"))),
            )
          ],
        ),
      );
    },
  );
}
