import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/utils/helpers/type.dart';
import 'package:flutter/material.dart';

extension TaskTypeExtension on TaskType {
  Color getColor() {
    switch (this) {
      case TaskType.done:
        return Colors.lightBlue;
      case TaskType.inProgress:
        return Colors.amber[700];
      default:
        return Colors.redAccent;
    }
  }

  String toStringValue() {
    switch (this) {
      case TaskType.done:
        return 'Erledigt';
      case TaskType.inProgress:
        return 'In Bearbeitung';
      default:
        return 'Offen';
    }
  }
}

extension Neumorphism on Widget {
  Container addNeumorphism({
    double borderRadius = kBorderRadius,
    Offset offset = const Offset(5, 5),
    double blurRadius = 10,
    Color topShadowColor = Colors.white60,
    Color bottomShadowColor = const Color(0x26234395),
  }) {
    return Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      boxShadow: [
        BoxShadow(
          offset: offset,
          blurRadius: blurRadius,
          color: bottomShadowColor,
        ),
        BoxShadow(
          offset: Offset(-offset.dx, -offset.dx),
          blurRadius: blurRadius,
          color: topShadowColor,
        )
      ]
      ),
      child: this,
    );
  }
}
