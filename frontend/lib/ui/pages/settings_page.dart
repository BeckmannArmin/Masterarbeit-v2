// ignore_for_file: prefer_if_elements_to_conditional_expressions

import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/controller/add_teammember_controller.dart';
import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/settings_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/ui/widgets/add_projectmember_dialog.dart';
import 'package:beebusy_app/ui/widgets/alert_dialog.dart';
import 'package:beebusy_app/ui/widgets/board_navigation.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/teammember_container.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../service/SizeConfig.dart';
import '../../utils/helpers/constants.dart';

class SettingsPage extends GetView<SettingsController> {
  static const String route = '/board/settings';

  final BoardController _boardController = Get.find();
  final ProjectService _projectService = Get.find();
  final AuthController _authController = Get.find();

  final TaskController _taskController = Get.put(TaskController());


  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context, height: height, width: width, allowFontScaling: true);
    
    MySize().init(context);

    return Scaffold(
      body: BoardNavigation(
        child: Padding(
          padding:  EdgeInsets.only(left: MySize.size10, right: MySize.size10, top: MySize.size25, bottom: MySize.size25),
          child: width <= 820 ? 
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              margin: EdgeInsets.only(top: (kSpacingUnit.w * 3).toDouble()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Obx(
                        () => Container(
                      width: Get.width,
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              _boardController.selectedProject.value.name ?? 'Projekt',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: MySize.size24,
                                color: const Color(0xff313133),
                              ),
                            ),
                          ),
                          Text(
                            ' - ${AppLocalizations.of(context).settingsLabel}',

                            style: TextStyle(
                              fontSize: MySize.size24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: MySize.size50),
                  Obx(
                        () => Form(
                      key: controller.formKey,
                      child: Row(
                        children: <Widget>[
                          BrownText(
                            AppLocalizations.of(context).projectNameLabel,
                            isBold: true,
                          ),
                          SizedBox(
                            width: MySize.size16,
                          ),
                    controller.isEditingTitle.value
                        ? Expanded(child: SizedBox(
                        child:  MyTextFormField(
                          maxLength: 50,
                          controller: controller.titleEditingController
                            ..text = _boardController
                                .selectedProject.value.name,
                          labelText: AppLocalizations.of(context)
                              .projectNameLabel,
                          validator: (String value) {
                            if (value.isBlank) {
                              return AppLocalizations.of(context)
                                  .emptyError;
                            }

                            if (value.length > 50) {
                              return AppLocalizations.of(context)
                                  .length50Error;
                            }
                            return null;
                          },
                        )

                    )):
                    BrownText(
                        _boardController.selectedProject.value.name ?? 'Projekt'),

                          if (controller.isEditingTitle.value)
                            Wrap(
                              children: <Widget>[
                                IconButton(
                                  iconSize: ScreenUtil()
                                      .setSp(kSpacingUnit.w * 2)
                                      .toDouble(),
                                  icon: const Icon(Icons.check),
                                  color: Theme.of(context).hintColor,
                                  onPressed: () {
                                    if (!controller.formKey.currentState.validate())
                                      return;

                                    controller.isEditingTitle.value = false;
                                    _projectService
                                        .updateName(
                                        projectId: _boardController
                                            .selectedProject.value.projectId,
                                        newName: controller
                                            .titleEditingController.value.text)
                                        .then((Project project) async {
                                      await _boardController.refreshUserProjects();
                                      _boardController
                                          .selectProject(project.projectId);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  iconSize: ScreenUtil()
                                      .setSp(kSpacingUnit.w * 2)
                                      .toDouble(),
                                  color: Theme.of(context).hintColor,
                                  onPressed: () {
                                    controller.isEditingTitle.value = false;
                                  },
                                ),
                              ],
                            )
                          else
                            Expanded(child: IconButton(
                              iconSize: ScreenUtil()
                                      .setSp(kSpacingUnit.w * 2)
                                      .toDouble(),
                              icon: const Icon(Icons.edit),
                              color: Theme.of(context).hintColor,
                              onPressed: () {
                                controller.isEditingTitle.value = true;
                              },
                            )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MySize.size25),
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 20,
                      direction: Axis.vertical,
                      children: <Widget>[
                        BrownText(
                          AppLocalizations.of(context).teamMembersLabel,
                          isBold: true,
                        ),
                        Container(
                          width: width,
                          child: Obx(
                                () => Wrap(
                                  direction: Axis.vertical,
                              spacing: MySize.size8,
                              children: <Widget>[
                                ...controller.projectMembers
                                    .toList()
                                    .map(
                                      (User u) => TeamMemberContainer(
                                        maxWidth: 350,
                                    name: '${u.firstname} ${u.lastname}',
                                    onPressed: () =>
                                        controller.removeProjectMember(u.userId),
                                    removable: _authController
                                        .loggedInUser.value.userId !=
                                        u.userId,
                                  ),
                                )
                                    .toList(),
                                Container(
                                  width: MySize.size250,
                                  constraints:  BoxConstraints(minHeight: MySize.size40),
                                  margin:  EdgeInsets.symmetric(vertical: MySize.size40),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).hintColor,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(MySize.size20)),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(MySize.size20),
                                    onTap: () => showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          GetBuilder<AddTeammemberController>(
                                            init: AddTeammemberController(),
                                            builder: (_) => AddTeamMemberDialog(),
                                          ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MySize.size50),
                  DangerZone(),
                ],
              ),
            ),
          ) :
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Obx(
                      () => Container(
                    width: Get.width,
                    child:
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            _boardController.selectedProject.value.name ?? 'Projekt',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MySize.size24,
                              color: const Color(0xff313133),
                            ),
                          ),
                        ),
                        Text(
                          ' - ${AppLocalizations.of(context).settingsLabel}',

                          style: TextStyle(
                            fontSize: MySize.size24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                  ),
                ),
                SizedBox(height: MySize.size50),
                Obx(
                      () => Form(
                    key: controller.formKey,
                    child: Row(
                      children: <Widget>[
                        BrownText(
                          AppLocalizations.of(context).projectNameLabel,
                          isBold: true,
                        ),
                        SizedBox(
                          width: MySize.size16,
                        ),
                  controller.isEditingTitle.value
                      ? Expanded(child: SizedBox(
                      child:  MyTextFormField(
                        maxLength: 50,
                        controller: controller.titleEditingController
                          ..text = _boardController
                              .selectedProject.value.name,
                        labelText: AppLocalizations.of(context)
                            .projectNameLabel,
                        validator: (String value) {
                          if (value.isBlank) {
                            return AppLocalizations.of(context)
                                .emptyError;
                          }

                          if (value.length > 50) {
                            return AppLocalizations.of(context)
                                .length50Error;
                          }
                          return null;
                        },
                      )

                  )):
                  BrownText(
                      _boardController.selectedProject.value.name ?? 'Projekt'),

                        if (controller.isEditingTitle.value)
                          Wrap(
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.check),
                                color: Theme.of(context).hintColor,
                                onPressed: () {
                                  if (!controller.formKey.currentState.validate())
                                    return;

                                  controller.isEditingTitle.value = false;
                                  _projectService
                                      .updateName(
                                      projectId: _boardController
                                          .selectedProject.value.projectId,
                                      newName: controller
                                          .titleEditingController.value.text)
                                      .then((Project project) async {
                                    await _boardController.refreshUserProjects();
                                    _boardController
                                        .selectProject(project.projectId);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear),
                                color: Theme.of(context).hintColor,
                                onPressed: () {
                                  controller.isEditingTitle.value = false;
                                },
                              ),
                            ],
                          )
                        else
                          Expanded(child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Theme.of(context).hintColor,
                            onPressed: () {
                              controller.isEditingTitle.value = true;
                            },
                          )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MySize.size25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BrownText(
                      '${AppLocalizations.of(context).teamMembersLabel}: ',
                      isBold: true,
                    ),
                    Expanded(
                      child: Obx(
                            () => Wrap(
                          spacing: MySize.size8,
                          children: <Widget>[
                            ...controller.projectMembers
                                .toList()
                                .map(
                                  (User u) => TeamMemberContainer(
                                name: '${u.firstname} ${u.lastname}',
                                onPressed: () =>
                                    controller.removeProjectMember(u.userId),
                                removable: _authController
                                    .loggedInUser.value.userId !=
                                    u.userId,
                              ),
                            )
                                .toList(),
                            Container(
                              width: MySize.size250,
                              constraints:  BoxConstraints(minHeight: MySize.size40),
                              margin:  EdgeInsets.symmetric(vertical: MySize.size40),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).hintColor,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(MySize.size20)),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(MySize.size20),
                                onTap: () => showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      GetBuilder<AddTeammemberController>(
                                        init: AddTeammemberController(),
                                        builder: (_) => AddTeamMemberDialog(),
                                      ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MySize.size100),
                DangerZone(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DangerZone extends GetView<BoardController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: BrownText(
            AppLocalizations.of(context).dangerZoneLabel,
            fontSize: 24,
          ),
        ),
        Container(
          width: 1200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DangerZoneRow(
                title: AppLocalizations.of(context).archiveProjectTitle,
                subtitle: AppLocalizations.of(context).archiveProjectInfo,
                buttonText: AppLocalizations.of(context).archiveProjectButton,
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => MyAlertDialog(
                    title: AppLocalizations.of(context).archiveProjectButton,
                    content:
                    AppLocalizations.of(context).archiveProjectQuestion,
                    onConfirm: controller.archiveProject,
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).hoverColor,
                thickness: 1,
              ),
              DangerZoneRow(
                title: AppLocalizations.of(context).deleteProjectTitle,
                subtitle: AppLocalizations.of(context).deleteProjectInfo,
                buttonText: AppLocalizations.of(context).deleteProjectButton,
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => MyAlertDialog(
                    title: AppLocalizations.of(context).deleteProjectButton,
                    content: AppLocalizations.of(context).deleteProjectQuestion,
                    onConfirm: controller.deleteProject,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DangerZoneRow extends StatelessWidget {
  const DangerZoneRow({
    @required this.title,
    @required this.subtitle,
    @required this.buttonText,
    @required this.onPressed,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BrownText(title, isBold: true),
              BrownText(subtitle, overflow: TextOverflow.clip,),
              const SizedBox(height: 15,),
              MediaQuery.of(context).size.width>600? Container():
              Center(
                child: MyRaisedButton(
                  buttonText: buttonText,
                  onPressed: onPressed,
                  isDangerButton: true,
                ),
              )

            ],
          ),
        ),

       MediaQuery.of(context).size.width>600?
       Expanded(
            flex: 1,
            child: MyRaisedButton(
          buttonText: buttonText,
          onPressed: onPressed,
          isDangerButton: true,
        ))
           :Container(),
      ],
    );
  }
}
