import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/teammember_container.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';
import '../../controller/create_task_controller.dart';

class AddTaskDialogBottomSheet extends GetView<CreateTaskController> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context).cancelButton,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    Text(AppLocalizations.of(context).createTaskTitle,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                         if (_formKey.currentState.validate()) {
                        controller.createTask(context);
                      }
                      },
                      child: Text(
                        AppLocalizations.of(context).saveLabel,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    RoundedInput(
                      controller: controller.titleController,
                      validator: (String value) {
                        if (value.isBlank) {
                          return AppLocalizations.of(context).emptyError;
                        }

                        if (value.length > 50) {
                          return AppLocalizations.of(context).length50Error;
                        }

                        return null;
                      },
                      icon: Icons.list,
                      size: const Size(30, 30),
                      labelText: AppLocalizations.of(context).taskTitleLabel,
                    ),
                    RoundedInput(
                      controller: controller.descriptionController,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      validator: (String value) {
                        if (value.isBlank) {
                          return AppLocalizations.of(context).emptyError;
                        }

                        if (value.length > 50) {
                          return AppLocalizations.of(context).length50Error;
                        }

                        return null;
                      },
                      icon: Icons.description_outlined,
                      size: const Size(30, 30),
                      labelText: AppLocalizations.of(context).descriptionLabel,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 25, top: 10),
                child: InkWell(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: controller.deadline.value,
                            firstDate: DateTime.now()
                                    .isBefore(controller.deadline.value)
                                ? DateTime.now()
                                : controller.deadline.value,
                            lastDate: controller.deadline.value
                                .add(const Duration(days: 3650)),
                            currentDate: controller.deadline.value,
                          ).then(controller.deadlineChanged);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        color: kPrimaryColor.withOpacity(.05)),
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                             showDatePicker(
                            context: context,
                            initialDate: controller.deadline.value,
                            firstDate: DateTime.now()
                                    .isBefore(controller.deadline.value)
                                ? DateTime.now()
                                : controller.deadline.value,
                            lastDate: controller.deadline.value
                                .add(const Duration(days: 3650)),
                            currentDate: controller.deadline.value,
                          ).then(controller.deadlineChanged);
                          },
                        ),
                        const SizedBox(width: 10),
                        Obx(() => BrownText(controller.deadlineString, fontSize: 16,)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: Obx(() => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (controller.possibleAssignees.isNotEmpty ||
                                  controller.assignees.isEmpty)
                                MyDropDown<ProjectMember>(
                                  width: double.infinity,
                                  hintText: AppLocalizations.of(context)
                                      .addAssigneeLabel,
                                  possibleSelections:
                                      controller.possibleAssignees,
                                  onChanged: controller.addAssignee,
                                  valueBuilder: (ProjectMember projectMember) =>
                                      projectMember.id,
                                  textBuilder: (ProjectMember projectMember) =>
                                      '${projectMember.user.firstname} ${projectMember.user.lastname}',
                                ),
                              const SizedBox(height: 5),
                              Expanded(
                                  child: Scrollbar(
                                key: ValueKey<int>(controller.assignees.length),
                                controller: _scrollController,
                                thumbVisibility: true,
                                child: ListView(
                                  controller: _scrollController,
                                  children: <Widget>[
                                    ...controller.assignees
                                        .toList()
                                        .map(
                                          (ProjectMember element) =>
                                              TeamMemberContainer(
                                            name:
                                                '${element.user.firstname} ${element.user.lastname}',
                                            onPressed: () => controller
                                                .removeAssignee(element.id),
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ))
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
