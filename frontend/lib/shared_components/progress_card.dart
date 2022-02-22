import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/constants/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressCardData {
  final int totalUndone;
  final int totalTaskInProgress;

  const ProgressCardData({
    this.totalUndone,
    this.totalTaskInProgress,
  });
}


class ProgressCard extends StatelessWidget {
  const ProgressCard({Key key, this.data, this.onPressedCheck}) : super(key: key);

  final ProgressCardData data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: kColorBlack,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(offset: const Offset(10, 30),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset(
                    ImageVectorPath.happy2,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: kSpacing,
              top: kSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Du hast ${data.totalUndone} offene Aufgaben',
                  style: TextStyle(fontWeight: FontWeight.w400, color: kFontColorPallets[1]),
                ),
                const SizedBox(height: 7.5,),
                Text(
                  data.totalTaskInProgress == 1 ? '${data.totalTaskInProgress} Aufgabe ist in Bearbeitung' : '${data.totalTaskInProgress} Aufgaben sind in Bearbeitung',
                  style: TextStyle(fontWeight: FontWeight.w400, color: kFontColorPallets[1]),
                ),
                const SizedBox(height: kSpacing,),
                ElevatedButton(
                  onPressed: onPressedCheck,
                  child: const Text('Überprüfen'),
                )
              ],
            ),
            )
        ],
      ),
    );
  }
}