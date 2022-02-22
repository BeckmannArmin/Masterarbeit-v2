import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_constants.dart';
import '../utils/helpers/type.dart';

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader({Key key, this.axis, this.onSelected}) : super(key: key);

  final Function(TaskType task) onSelected;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final Rx<TaskType> task = Rx(null);

    return Obx(
      () => (axis == Axis.horizontal) ? Row(children: [
          const Text('Task Overview', style: TextStyle(fontWeight: FontWeight.w600),),
          const Spacer(),
          ..._listButton(
            task: task.value,
            onSelected: (TaskType value) {
              task.value = value;
              onSelected(value);
            }
          )
        ],)
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Task Overview', style: TextStyle(fontWeight: FontWeight.w600),),
            const SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _listButton(task: task.value, onSelected: (value) {
                  task.value = value;
                  onSelected(value);
                }),
              ),
            )
          ],
        )
    );
  }


  List<Widget> _listButton({
    TaskType task,
    Function(TaskType value) onSelected,
  }) {
    return [
      _button(
        selected: task == TaskType.created,
        label: 'Alle Aufgaben',
        onPressed: () {
          task = TaskType.created;
          onSelected(TaskType.created);
        },
      ),
      _button(
        selected: task == TaskType.inReview,
        label: 'Überprüfung',
        onPressed: () {
          task = TaskType.inReview;
          onSelected(TaskType.inReview);
        },
      ),
      _button(
        selected: task == TaskType.inProgress,
        label: 'Zu erledigen',
        onPressed: () {
          task = TaskType.inProgress;
          onSelected(TaskType.inProgress);
        },
      ),
      _button(
        selected: task == TaskType.done,
        label: 'Done',
        onPressed: () {
          task = TaskType.done;
          onSelected(TaskType.done);
        },
      ),
    ];
  }

    Widget _button({
    bool selected,
    String label,
    Function() onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
        ),
        style: ElevatedButton.styleFrom(
          primary: selected
              ? Theme.of(Get.context).cardColor
              : Theme.of(Get.context).canvasColor,
          onPrimary: selected ? kFontColorPallets[0] : kFontColorPallets[2],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}