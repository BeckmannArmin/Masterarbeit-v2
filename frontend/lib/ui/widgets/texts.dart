import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyTitle extends StatelessWidget {
  const BodyTitle({
    @required this.title,
    this.trailing = '',
  });

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textScaleFactor: 3,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Text(
          trailing,
          textScaleFactor: 3,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

class BrownText extends StatelessWidget {
  const BrownText(this.text, {this.textAlign, this.overflow = TextOverflow.ellipsis, this.isBold = false, this.fontSize});

  final String text;
  final bool isBold;
  final double fontSize;
  final TextOverflow overflow;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: fontSize,
        height: 1.5,
        fontWeight: isBold ? FontWeight.bold : null,
      ),
    );
  }
}
