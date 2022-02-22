import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class ActiveProjectCard extends StatelessWidget {
  const ActiveProjectCard({
    this.child,
    this.onPressedSeeAll,
    Key key,
  }) : super(key: key);

  final Widget child;
  final Function() onPressedSeeAll;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: kColorBlack,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kSpacing),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _title('Meine aktiven Projekte'),
                _seeAllButton(onPressed: onPressedSeeAll),
              ],
            ),
            const Divider(
              thickness: 1,
              height: kSpacing,
            ),
            const SizedBox(height: kSpacing),
            child,
          ],
        ),
      ),
    );
  }

  Widget _title(String value) {
    return Text(
      value,
      style: const TextStyle(fontWeight: FontWeight.w600, color: kColorBlack, letterSpacing: 1),
    );
  }

  Widget _seeAllButton({Function() onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: const Text('Alle Projekte'),
      style: TextButton.styleFrom(primary: kFontColorPallets[1],),
    );
  }
}
