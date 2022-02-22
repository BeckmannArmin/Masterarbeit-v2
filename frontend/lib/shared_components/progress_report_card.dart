import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../constants/app_constants.dart';


class ProgressReportCardData {
  final double percent;
  final String title;
  final int task;
  final int doneTask;
  final int undoneTask;

  const ProgressReportCardData({
    this.percent,
    this.title,
    this.task,
    this.doneTask,
    this.undoneTask,
  });
}

class ProgressReportCard extends StatelessWidget {
  const ProgressReportCard({Key key, this.data}) : super(key: key);

  final ProgressReportCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(111, 88, 255, 1),
            Color.fromRGBO(157, 86, 248, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15,),
              _RichText(value1: '${data.task} ', value2: 'Task',),
              const SizedBox(height: 3,),
              _RichText(value1: '${data.doneTask} ', value2: 'Erledigte Aufgaben',),
              const SizedBox(height: 3,),
              _RichText(value1: '${data.undoneTask} ', value2: 'Offene Aufgaben',),
            ]
          ),
          const Spacer(),
          _Indicator(percent: data.percent),
        ],
      ),
    );
  }
}


/* ------------------------------> COMPONENTS <----------------------------- */

class _RichText extends StatelessWidget {
  const _RichText({
    this.value1,
    this.value2,
    Key key,
  }) : super(key: key);

  final String value1;
  final String value2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: kColorWhite,
          fontWeight: FontWeight.w500,
        fontSize: 12,
        ),
        children: [
          TextSpan(text: value1),
          TextSpan(
            text: value2,
            style: const TextStyle(
              color:  kColorWhite,
              fontWeight: FontWeight.w200,
            )
          )
        ]
      ) 
      );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({this.percent, Key key}) : super(key: key);

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
        children: [
          Text(
            (percent * 100).toString() + ' %',
            style: const TextStyle(fontWeight: FontWeight.w500, color: kColorWhite),
          ),
          const Text(
            'Erledigt',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, color: kColorWhite),
          ),
        ],
      ),
      progressColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(.3),
    );
  }
}