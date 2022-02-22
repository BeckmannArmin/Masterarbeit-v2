import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class TeamMember extends StatelessWidget {
  const TeamMember({
    this.totalMember,
    this.onPressedAdd,
    Key key,
  }) : super(key: key);

  final int totalMember;
  final Function() onPressedAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kFontColorPallets[0],
            ),
            children: [
              const TextSpan(text: 'Dein Team ', style: TextStyle(color: kColorBlack)),
              TextSpan(
                text: '($totalMember)',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: kColorBlack,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onPressedAdd,
          icon: const Icon(EvaIcons.plus),
          tooltip: 'Füge ein weiteres Teammitglied hinzu',
        )
      ],
    );
  }
}
