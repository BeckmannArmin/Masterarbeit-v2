import 'package:beebusy_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressReportCardData {

  final double percent;
  final String title;
  final int task;
  final int doneTask;
  final int undoneTask;


const ProgressReportCardData({
  @required this.percent,
    @required this.title,
    @required this.task,
    @required this.doneTask,
    @required this.undoneTask
});

}

class ProgressReportCard extends StatelessWidget {
  const ProgressReportCard({
    Key key,
    @required this.data,
    }) : super(key: key);

  final ProgressReportCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0XFFF2994A),
            Color(0XFFF2C94C)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(kBorderRadius)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Wrap(
          spacing: 5,
          runSpacing: 5,
           direction: Axis.vertical,
            children: <Widget>[
              Text(data.title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18)),
              const SizedBox(height: kSpacing),
              _RichText(value1: '${data.task}', value2: ' Task',),
              _RichText(value1: '${data.doneTask}',
               value2: data.doneTask == 1 ?
               ' ${AppLocalizations.of(context).doneTask}':
               ' ${AppLocalizations.of(context).doneTasks}'
               ),
              _RichText(value1: '${data.undoneTask}',
               value2:
               data.undoneTask == 1 ?
                ' ${AppLocalizations.of(context).undoneTask}'
                : ' ${AppLocalizations.of(context).undoneTasks}'
                )
            ],
          ),
          _Indicator(percent: data.percent / 100,)
        ],
      ),
    );
  }
}

class _RichText extends StatelessWidget {
  const _RichText({Key key, @required this.value1, @required this.value2}) : super(key: key);

  final String value1;
  final String value2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14,color: Colors.white),
        children: <InlineSpan>[
          TextSpan(text: value1),
          TextSpan(text: value2)
        ]
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({Key key, @required this.percent}) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 1000,
      radius: width >= 820 ? 
      (width > 1000 ? 140 : 115) : 
      140,
      lineWidth:width >= 820 ? 
      (width > 1000 ? 15 : 7.5) : 
      15,
      percent: percent,
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if ((percent * 100).isNaN) const Text('0 %', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),) else Text((percent * 100).toStringAsFixed(2) + ' %', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          Text(AppLocalizations.of(context).completedLabel, style: const TextStyle(fontWeight: FontWeight.w400,color: Colors.white),)
        ],
      ),
      progressColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(.3),
    );
  }
}