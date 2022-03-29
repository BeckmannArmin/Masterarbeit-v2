import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_project_controller.dart';
import 'package:beebusy_app/controller/edit_task_controller.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/ui/pages/profile_page.dart';
import 'package:beebusy_app/ui/widgets/add_project_dialog.dart';
import 'package:beebusy_app/ui/widgets/edit_task_dialogv2.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants/app_constants.dart';

const bool _showArchiveButton = false;

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({this.showActions = false});

  final bool showActions;

  @override
  Widget build(BuildContext context) {

    return Material(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(onPressed: () {
              Scaffold.of(context).openDrawer();
            }, icon: const Icon(Icons.menu)),
            const Spacer(),
            GetBuilder<BoardController>(
                init: BoardController(),
                builder: (BoardController controller) {
                  return controller.selectedProject.value.name != null
                      ? Container(
                          child: Center(
                            child: BrownText(
                              controller.selectedProject.value.name,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Container();
                }),
            const Spacer(),
            if (showActions)
              Row(
                children: <Widget>[
                  IconButton(onPressed: () {
                    showSearch<dynamic>(context: context, delegate: MySearchDelegate()
                    );
                  }, icon: const Icon(Icons.search)),
                  /* GetX<AuthController>(builder: (AuthController controller) {
                    final User user = controller.loggedInUser.value;
                    return width < 481
                        ? Container()
                        : SizedBox(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: BrownText(
                                  '${user.firstname} ${user.lastname}'),
                            ),
                          );
                  }), */
                  const SizedBox(width: 8),
                  MyPopupMenuButton(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MySearchDelegate extends SearchDelegate<dynamic> {

  List<Task> suggestedTasks = BoardController().tasks;

  @override
  Widget buildLeading(BuildContext context) => IconButton(onPressed: () {
    close(context, null);
  }, icon: const Icon(Icons.arrow_back));

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
          //close(context, null);
        }
      }, icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return GetBuilder<BoardController>(
      init: BoardController(),
      builder: (BoardController controller) {
        
       final List<Task> filteredTasks = suggestedTasks.where((Task task) {
          final String result = task.title.toLowerCase();
          final String input = query.toLowerCase();

          return result.contains(input);
        }).toList();

        return ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder:  (_ , int index) {
                final Task task = filteredTasks[index];
                return Card(
                  elevation: 2,
                  shadowColor: Colors.black,
                  child: ListTile(
                      trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(onPressed: () {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(kBorderRadius),
                                  topLeft: Radius.circular(kBorderRadius)),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.background,
                            context: context,
                            builder: (BuildContext context) {
                              return GetBuilder<EditTaskController>(
                                init: EditTaskController(task: task),
                                builder: (_) => EditTaskDialogBottomSheet(),
                              );
                            });
                        }, icon: const Icon(Icons.edit)),
                        IconButton(onPressed: () {

                        }, icon: const Icon(Icons.delete)),
                      ],
                    ),
                    title: Text(task.title),
                    onTap: () {
                      query = task.title;
                    },
            
                  ),
                );
              }
              );
      }
    );
  }
}
class ProjectDropDown extends StatelessWidget {
  ProjectDropDown({Key key, this.selectedProjectId}) : super(key: key);

  final int selectedProjectId;
  final BoardController boardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: Get.currentRoute.contains(ProfilePage.route)
          ? null
          : selectedProjectId,
      child: Row(
        children: <Widget>[
          BrownText(AppLocalizations.of(context).projectsLabel),
          Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      onSelected: (int value) {
        switch (value) {
          case -1:
            showDialog<void>(
              context: context,
              builder: (BuildContext context) =>
                  GetBuilder<CreateProjectController>(
                init: CreateProjectController(),
                builder: (_) => AddProjectDialog(),
              ),
            );
            break;
          default:
            if (value >= 0) {
              boardController.selectProject(value);
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        ...boardController.activeUserProjects
            .map<PopupMenuEntry<int>>(
              (Project project) => PopupMenuItem<int>(
                value: project.projectId,
                child: BrownText(project.name),
              ),
            )
            .toList(),
        if (boardController.activeUserProjects.isNotEmpty)
          const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: -1,
          child: BrownText(AppLocalizations.of(context).newProjectLabel),
        ),
        // no archive view
        if (_showArchiveButton)
          PopupMenuItem<int>(
            value: -2,
            child: BrownText(AppLocalizations.of(context).archiveLabel),
          ),
      ],
    );
  }
}

class MyPopupMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: GetX<AuthController>(
          builder: (AuthController controller) => Text(
            controller.loggedInUser.value?.nameInitials ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: BrownText(AppLocalizations.of(context).profileLabel),
        ),
        PopupMenuItem<int>(
          enabled: false,
          value: -1,
          child: Row(
            children: <Widget>[
              BrownText(
                AppLocalizations.of(context).enableDarkModeLabel,
              ),
              const Spacer(),
              ValueBuilder<bool>(
                initialValue: Get.isDarkMode,
                builder: (bool isDarkMode, void updater(bool _)) {
                  return Switch(
                    value: isDarkMode,
                    onChanged: (bool isDarkMode) {
                      updater(isDarkMode);
                      final GetStorage storage = GetStorage('theme');
                      storage.write('isDarkMode', isDarkMode);
                      Get.changeThemeMode(
                        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: BrownText(AppLocalizations.of(context).logoutLabel),
        ),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            //Get.toNamed<void>(ProfilePage.route)
            Get.find<BoardController>().changeTabIndex(2);
            break;
          case 1:
            Get.find<AuthController>().logout();
            break;
        }
      },
    );
  }
}
