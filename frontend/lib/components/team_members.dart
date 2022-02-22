import 'package:beebusy_app/constants/app_constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class _TeamMember extends StatelessWidget {
  const _TeamMember({Key key, this.totalMember, this.onPressedAdd})
      : super(key: key);

  final int totalMember;
  final Function() onPressedAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
            text: TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kFontColorPallets[0]),
                    children: [
                      const TextSpan(text: 'Team Mitglieder'),
                      TextSpan(
                        text: '($totalMember)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kFontColorPallets[2],
                        ),
                      ),
                    ],
                    ),),
                    const Spacer(),
                    IconButton(
                      onPressed: onPressedAdd, 
                      icon: const Icon(EvaIcons.plus),
                      tooltip: 'Füge ein neues Teammitglied hinzu',
                      )
      ],
    );
  }
}