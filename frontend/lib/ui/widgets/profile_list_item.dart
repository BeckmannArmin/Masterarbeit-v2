import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/utils/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final VoidCallback onTap;
  final Widget widget;
  final bool hasWidget;

  const ProfileListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
    this.onTap,
    this.widget,
    this.hasWidget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (kSpacingUnit.w * 5.5).toDouble(),
      margin: EdgeInsets.symmetric(
        horizontal: (kSpacingUnit.w * 4).toDouble(),
      ).copyWith(
        bottom: (kSpacingUnit.w * 2).toDouble(),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: (kSpacingUnit.w * 2).toDouble(),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: Theme.of(context).primaryColor.withOpacity(0.05),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: (kSpacingUnit.w * 2.5).toDouble(),
          ),
          SizedBox(width: (kSpacingUnit.w * 1.5).toDouble()),
          Text(
            text,
            style: kTitleTextStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (hasNavigation)
            Icon(
              Icons.arrow_right,
              size: (kSpacingUnit.w * 2.5).toDouble(),
            ),
          if (hasWidget)
            Container(
              child: widget,
            )
        ],
      ),
    );
  }
}