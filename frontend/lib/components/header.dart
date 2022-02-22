import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../shared_components/search_field.dart';
import '../shared_components/today_text.dart';

class SideMenuHeader extends StatelessWidget {
  const SideMenuHeader({Key key}) : super(key: key);

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
