import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const int kSpacingUnit = 10;

const Color kYellowLight = Color(0xFFFFF7EC);
const Color kYellow = Color(0xFFFAF0DA);
const Color kYellowDark = Color(0xFFEBBB7F);

const Color kRedLight = Color(0xFFFCF0F0);
const Color kRed = Color(0xFFFBE4E6);
const Color kRedDark = Color(0xFFF08A8E);

const Color kBlueLight = Color(0xFFEDF4FE);
const Color kBlue = Color(0xFFE1EDFC);
const Color kBlueDark = Color(0xFFC0D3F8);


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

