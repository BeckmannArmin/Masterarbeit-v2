import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_project_controller.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/teammember_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class AddModalProjectDialog extends GetView<CreateProjectController> {
  
  final BoardController boardController = Get.find();
  final AuthController authController = Get.find();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
   
      return Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        },
                       child: Text(AppLocalizations.of(context).cancelButton, style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                       ),
                       Text(
                       AppLocalizations.of(context).createProjectTitle, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)
                       ),
                       TextButton(onPressed: () {
                          if (_formKey.currentState.validate() && controller.projectMembers.isNotEmpty) {
                            controller.createProject();
                          }
                       },
                       child: Text(AppLocalizations.of(context).saveLabel, style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                       )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                 Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: 
                    RoundedInput(
                      controller: controller.projectTitleController,
                      validator: (String value) {
                      if(value.isBlank) {
                                return AppLocalizations.of(context).emptyError;
                              }
            
                              if(value.length > 50) {
                                return AppLocalizations.of(context).length50Error;
                              }
            
                              return null;
                    },icon: Icons.list, size: const Size(30,30), labelText: AppLocalizations.of(context).projectNameLabel,)),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                      child: Column(
                        children: <Widget>[     
                          Container(
                            constraints: const BoxConstraints(
                              maxHeight: 250
                            ),
                            child: Obx(
                                  () => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      MyDropDown<User>(
                                        width: double.infinity,
                                        hintText: AppLocalizations.of(context)
                                            .addTeamMemberLabel,
                                        possibleSelections: controller.userList,
                                        onChanged: controller.addProjectMember,
                                        valueBuilder: (User user) => user.userId,
                                        textBuilder: (User user) =>
                                            '${user.firstname} ${user.lastname}',
                                      ).build(context),
                                      const SizedBox(height: 5),
                                      Expanded(
                                        child: Scrollbar(
                                          key: ValueKey<int>(controller.projectMembers.length),
                                          controller: _scrollController,
                                          thumbVisibility: true,
                                          child: ListView(
                                            controller: _scrollController,
                                            children: <Widget>[
                                              ...controller.projectMembers
                                                  .toList()
                                                  .map(
                                                    (User u) => TeamMemberContainer(
                                                      name:
                                                          '${u.firstname} ${u.lastname}',
                                                      onPressed: () => controller
                                                          .removeProjectMember(u.userId),
                                                      removable: authController
                                                              .loggedInUser
                                                              .value
                                                              .userId !=
                                                          u.userId,
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
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      );
  }
}
