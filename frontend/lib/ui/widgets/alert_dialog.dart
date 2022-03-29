import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({this.title, this.content, this.onConfirm});

  final String title;
  final String content;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: BrownText(title),
      ),
      content: BrownText(content, overflow: TextOverflow.clip, textAlign: TextAlign.center,),
      actions: <Widget>[
        MyFlatButton(
          buttonText: AppLocalizations.of(context).cancelButton,
          onPressed: () => Get.back<void>(),
        ),
        const SizedBox(
          height: kSpacing * .25,
        ),
        MyRaisedButton(
          buttonText: AppLocalizations.of(context).continueButton,
          onPressed: onConfirm,
          isDangerButton: true,
        ),
      ],
    );
  }
}
