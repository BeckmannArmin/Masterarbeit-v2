import 'package:beebusy_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
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
            Color.fromRGBO(111, 88, 255, 1),
            Color.fromRGBO(157, 86, 248, 1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(kBorderRadius)
      ),
      child: Row(
        children: <Widget>[
          Wrap(
          spacing: 5,
           direction: Axis.vertical,
            children: <Widget>[
              Text(data.title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
              _RichText(value1: '${data.task}', value2: ' Task',),
              _RichText(value1: '${data.doneTask}', value2: ' erledigte Aufgaben'),
              _RichText(value1: '${data.undoneTask}', value2: ' unerledigte Aufgaben')
            ],
          ),
          _Indicator(percent: data.percent,)
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
    return CircularPercentIndicator(
      radius: 140,
      lineWidth: 15,
      percent: percent,
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text((percent * 100).toString() + ' %', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          const Text('Completed', style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white),)
        ],
      ),
      progressColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(.3),
    );
  }
}