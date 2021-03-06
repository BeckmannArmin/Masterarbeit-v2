import 'package:flutter/material.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ScrollController controller;

  ScrollToHideWidget(
      {Key key,
      this.duration = const Duration(milliseconds: 300),
      @required this.child,
      @required this.controller})
      : super(key: key);

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    if (widget.controller.position.pixels >= 300) {
      hide();
    } else {
      show();
    }
  }

  void show() {
    if (!isVisible)
      setState(() {
        isVisible = true;
      });
  }

  void hide() {
    if (isVisible)
      setState(() {
        isVisible = false;
      });
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
      duration: widget.duration,
      height: isVisible ? 70 : 0,
      child: Wrap(children: <Widget>[widget.child]));
}
