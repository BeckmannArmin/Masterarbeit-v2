import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/create_task_controller.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/shared_components/responsive_builder.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/teammember_container.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class AddTaskDialog extends GetView<CreateTaskController> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (BuildContext context, BoxConstraints constraints) {
        return _buildDialog(context, constraints);
      },
      tabletBuilder: (BuildContext context, BoxConstraints constraints) {
        return _buildDialog(context, constraints);
      },
      desktopBuilder: (BuildContext context, BoxConstraints constraints) {
        return _buildDialog(context, constraints);
      },
    );
  }

  Widget _buildDialog(BuildContext context, BoxConstraints constraints) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(35.0),
          width: constraints.maxWidth > 1100 ? 750 : 500 ,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: BodyTitle(
                    title: AppLocalizations.of(context).createTaskTitle,
                  ),
                ),
                const SizedBox(
                  height: kSpacing * 2,
                ),
                Flexible(
                  child: MyTextFormField(
                    width: double.infinity,
                    controller: controller.titleController,
                    labelText: AppLocalizations.of(context).taskTitleLabel,
                    maxLines: 3,
                    minLines: 1,
                    maxLength: 50,
                    validator: (String value) {
                      if (value == null || value.isBlank) {
                        return AppLocalizations.of(context).emptyError;
                      }

                      if (value.length > 50) {
                        return AppLocalizations.of(context).length50Error;
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                MyTextFormField(
                  width: double.infinity,
                  controller: controller.descriptionController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  labelText: AppLocalizations.of(context).descriptionLabel,
                ),
                const SizedBox(
                  height: kSpacing * 2,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        child: Center(
                          child: BrownText(
                            AppLocalizations.of(context).assigneeLabel,
                          ),
                        ),
                        height: 40,
                      ),
                      const SizedBox(
                        width: kSpacing,
                      ),
                      Container(
                        width: 250,
                        color: Colors.red,
                        child: Obx(
                          () => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (controller.possibleAssignees.isNotEmpty ||
                                  controller.assignees.isEmpty)
                                MyDropDown<ProjectMember>(
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
                              Expanded(
                                child: Scrollbar(
                                  key: ValueKey<int>(
                                      controller.assignees.length),
                                  controller: _scrollController,
                                  isAlwaysShown: true,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BrownText(AppLocalizations.of(context).deadlineLabel),
                    Obx(() => BrownText(controller.deadlineString)),
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: controller.deadline.value,
                          firstDate:
                              DateTime.now().isBefore(controller.deadline.value)
                                  ? DateTime.now()
                                  : controller.deadline.value,
                          lastDate: controller.deadline.value
                              .add(const Duration(days: 3650)),
                          currentDate: controller.deadline.value,
                        ).then(controller.deadlineChanged);
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MyFlatButton(
                        buttonText: AppLocalizations.of(context).cancelButton,
                        onPressed: () => Get.back<void>(),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: MyRaisedButton(
                        buttonText: AppLocalizations.of(context).saveLabel,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            controller.createTask(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
