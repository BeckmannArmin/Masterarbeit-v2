import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/constants/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressCardData {
  final int totalUndone;
  final int totalTaskInProgress;

  const ProgressCardData({
    @required this.totalUndone,
    @required this.totalTaskInProgress,
  });
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({Key key, @required this.data, this.onPressedCheck})
      : super(key: key);

  final ProgressCardData data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius)),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(10, 30),
                child: SizedBox(
                    height: 200,
                    width: 200,
                    child: SvgPicture.asset(
                      ImageVectorPath.happy2,
                      fit: BoxFit.fitHeight,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kSpacing, left: kSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.totalUndone == 1
                      ? 'Du hast für heute ${data.totalUndone} unerledigte Aufgabe.'
                      : 'Du hast für heute ${data.totalUndone} unerledigte Aufgaben.',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: kSpacing / 4),
                Text(
                  data.totalTaskInProgress == 1
                      ? 'Du hast ${data.totalTaskInProgress} Aufgabe in Bearbeitung.'
                      : 'Du hast ${data.totalTaskInProgress} Aufgaben in Bearbeitung.',
                  style: TextStyle(color: kFontColorPallets[1]),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                if (MediaQuery.of(context).size.width < 800)
                ElevatedButton(
                    onPressed: onPressedCheck, child: const Text('Check')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
