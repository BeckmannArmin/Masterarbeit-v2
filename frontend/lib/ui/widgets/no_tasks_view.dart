import 'package:beebusy_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class EmptyTaskView extends StatelessWidget {
  const EmptyTaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: kSpacing),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(100)),
            child: const Icon(
              Icons.task_outlined,
              size: 65,
              color: Color(0xFFFAAB21),
            ),
          ),
          const SizedBox(
            height: kSpacing,
          ),
          Text(
            AppLocalizations.of(context).allDoneLabel,
            style: const TextStyle(
               fontSize: 19,
                height: 1.55,
            ),
          ),
           const SizedBox(
            height: kSpacing * 1/4 ,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                height: 1.55,
                color: Colors.grey.shade400
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: '${AppLocalizations.of(context).readyToWorkLabel} ',
                ),
                WidgetSpan(
                    child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      color: const Color(0xFFFAAB21)),
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.black,
                  ),
                )),
                TextSpan(
                  text: ' ${AppLocalizations.of(context).createThemLabel}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
