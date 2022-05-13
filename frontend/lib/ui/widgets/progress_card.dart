import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/constants/asset_path.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      elevation: 4,
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
                BrownText(
                  AppLocalizations.of(context).planToday,
                  isBold: true,
                  fontSize: 18,
                ),
                const SizedBox(height: kSpacing,),
                Text(
                  data.totalUndone == 1
                      ? '${AppLocalizations.of(context).forToday} ${data.totalUndone} ${AppLocalizations.of(context).undoneTask}.'
                      : '${AppLocalizations.of(context).forToday} ${data.totalUndone} ${AppLocalizations.of(context).undoneTasks}.',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: kSpacing / 4),
                Text(
                 '${data.totalUndone}/${data.totalTaskInProgress} ${AppLocalizations.of(context).taskInProgress}.',
                  style: TextStyle(fontWeight: FontWeight.w500, color: kFontColorPallets[1],
                  fontSize: 16
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                if (MediaQuery.of(context).size.width < 800)
                ElevatedButton(
                    onPressed: onPressedCheck, child: Text(AppLocalizations.of(context).check)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
