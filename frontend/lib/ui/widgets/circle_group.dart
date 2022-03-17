import 'package:flutter/material.dart';
class CircleGroup extends StatelessWidget {

  CircleGroup({
    Key key,
    this.groupHeight,
    this.groupWidth,
    this.itemCount,
    this.insideRadius,
    this.outSideRadius,
    this.backgroundImage,
    this.widthFactor,
    this.backgroundColor
  }) : super(key: key);


  final double groupWidth;
  final double groupHeight;
  final Color backgroundColor;
  final int itemCount;
  final double insideRadius;
  final double outSideRadius;
  final List<String> backgroundImage;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: groupWidth ?? 150,
      height: groupHeight ?? 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount ?? 4,
        itemBuilder: (BuildContext context, int index) {
          return Align(
            widthFactor: widthFactor ?? 0.6,
            child: CircleAvatar(
              radius : outSideRadius ?? 24,
              backgroundColor:  backgroundColor ?? Colors.white,
              child: backgroundImage[index].contains('http') == false?
              CircleAvatar(
                radius: insideRadius ?? 20,
                child: Center(child: Text(backgroundImage[index]),),
              )
                  :CircleAvatar(
                radius: insideRadius ?? 20,
                backgroundImage: NetworkImage(
                    backgroundImage[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}



