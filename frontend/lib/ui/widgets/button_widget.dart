import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({Key key, @required this.text, @required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
    );
  }
}
