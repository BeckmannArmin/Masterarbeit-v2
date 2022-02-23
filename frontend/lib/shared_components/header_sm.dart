import 'package:beebusy_app/shared_components/search_field.dart';
import 'package:beebusy_app/shared_components/today_text.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';


class Header extends StatelessWidget {
  const Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TodayText(),
        const SizedBox(width: kSpacing),
        Expanded(child: SearchField()),
      ],
    );
  }
}
