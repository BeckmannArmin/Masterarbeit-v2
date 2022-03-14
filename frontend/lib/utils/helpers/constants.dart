import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const int kSpacingUnit = 10;

final TextStyle kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7).toDouble(),
  fontWeight: FontWeight.w600,
);

final TextStyle kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5).toDouble(),
  fontWeight: FontWeight.w100,
);


final TextStyle kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5).toDouble(),
  fontWeight: FontWeight.w400,
);

