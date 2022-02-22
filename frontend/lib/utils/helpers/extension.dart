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
