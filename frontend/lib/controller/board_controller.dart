import 'package:beebusy_app/constants/asset_path.dart';
import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/shared_components/project_card.dart';
import 'package:beebusy_app/shared_components/task_card.dart';
import 'package:beebusy_app/ui/pages/board_page.dart';
import 'package:beebusy_app/ui/pages/dashboard_page.dart';
import 'package:beebusy_app/ui/pages/profile_page.dart';
import 'package:beebusy_app/ui/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared_components/profile_user.dart';
import '../utils/helpers/type.dart';

class BoardController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final AuthController _authController = Get.find();
  final TaskController _taskController = Get.find();
  final ProjectService _projectService = Get.find();

  final RxList<Project> _allUserProjects = <Project>[].obs;
  final RxList<Project> activeUserProjects = <Project>[].obs;
  final Rx<Project> selectedProject = Project().obs;
  final RxBool isLoadingUserProjects = true.obs;

  RxList<Task> get tasks => _taskController.tasks;

  //final RxString currentRoute = BoardPage.route.obs;

  // Change route to dashboard for now
  final RxString currentRoute = DashboardPage.route.obs;

  @override
  void onInit() {
    super.onInit();

    activeUserProjects.bindStream(
      _allUserProjects.stream.map(
        (List<Project> event) =>
            event.where((Project element) => !element.isArchived).toList(),
      ),
    );

    ever(
      selectedProject,
      _taskController.refreshTasks,
      condition: () => selectedProject.value.projectId != null,
    );
  }

  @override
  void onReady() {
    super.onReady();
    refreshUserProjects();
  }

  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState.openDrawer();
    }
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage(ImageRasterPath.logo1),
      projectName: 'BeeBusy',
      releaseTime: DateTime.now()
    );
  }

  // TODO(armin)
  ProfileUser getProfil() {
    return const ProfileUser(
      name: 'Armin',
      email: 'arbe0006@stud.hs-kl.de',
    );
  }

   // TODO(armin)
  List<ImageProvider> getTeamMembers() {
    return const [
      AssetImage(ImageRasterPath.avatar1),
      AssetImage(ImageRasterPath.avatar2),
      AssetImage(ImageRasterPath.avatar3),
      AssetImage(ImageRasterPath.avatar4),
      AssetImage(ImageRasterPath.avatar5),
      AssetImage(ImageRasterPath.avatar6),
    ];
  }

   // TODO(armin)
  List<TaskCardData> getAllTask() {
    return [
      const TaskCardData(
        title: 'Make this dynamic',
        dueDay: 10,
        type: TaskType.inProgress,
        totalContributors: 30,
        profilContributors: [
          
        ],
      ),
      const TaskCardData(
        title: 'Fetch the contributors dynamically',
        dueDay: 10,
        type: TaskType.inProgress,
        totalContributors: 30,
        profilContributors: [
          
        ],
      ),

      const TaskCardData(
        title: 'Another test task hardcoded lala',
        dueDay: 10,
        type: TaskType.inProgress,
        totalContributors: 30,
        profilContributors: [
          
        ],
      ),
    ];
  }

   // TODO(armin)
  List<ProjectCardData> getActiveProject() {
    return [
      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage(ImageRasterPath.logo2),
        projectName: 'BeeBussy',
        releaseTime: DateTime.now().add(const Duration(days: 130))
      ),

      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage(ImageRasterPath.logo3),
        projectName: 'BeeBussy',
        releaseTime: DateTime.now().add(const Duration(days: 130))
      ),

      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage(ImageRasterPath.logo4),
        projectName: 'BeeBussy',
        releaseTime: DateTime.now().add(const Duration(days: 130))
      ),
    ];
  }

  Future<void> refreshUserProjects() {
    final User currentUser = _authController.loggedInUser.value;
    isLoadingUserProjects.value = true;
    return _projectService.getAllUserProjects(currentUser.userId).then(
      (List<Project> projects) {
        _allUserProjects.clear();
        _allUserProjects.addAll(projects);
        if (activeUserProjects.isNotEmpty &&
            selectedProject.value.projectId == null) {
          selectProject(activeUserProjects.first.projectId);
        }
      },
    ).whenComplete(() => isLoadingUserProjects.value = false);
  }

  void refreshTasks() {
    _taskController.refreshTasks(selectedProject.value);
  }

  void selectProject(int projectId) {
    _taskController.loadTasksOperation?.cancel();
    if (projectId != null) {
      selectedProject.value = activeUserProjects.firstWhere(
        (Project project) => project.projectId == projectId,
        orElse: () => Project(),
      );
    } else {
      selectedProject.value = Project();
    }

    if(Get.currentRoute.contains(ProfilePage.route)) {
      Get.back<void>();
      selectedProject.refresh();
    }
  }

  void selectBoard() {
    currentRoute.value = BoardPage.route;
    Get.back<void>();
  }

  void selectSettings() {
    currentRoute.value = SettingsPage.route;
    Get.toNamed<void>(SettingsPage.route);
  }

  void deleteProject() {
    Get.back<void>();
    selectBoard();

    final int projectToDeleteId = selectedProject.value.projectId;
    _allUserProjects.removeWhere(
      (Project element) => element.projectId == projectToDeleteId,
    );

    if (activeUserProjects.isNotEmpty) {
      selectProject(activeUserProjects.first.projectId);
    } else {
      selectProject(null);
    }

    _projectService.deleteProject(projectToDeleteId);
  }

  void archiveProject() {
    Get.back<void>();
    selectBoard();

    final int projectToArchiveId = selectedProject.value.projectId;

    _projectService
        .archiveProject(projectToArchiveId)
        .then((Project value) => refreshUserProjects())
        .then(
      (_) {
        if (activeUserProjects.isNotEmpty) {
          selectProject(activeUserProjects.first.projectId);
        } else {
          selectProject(null);
        }
      },
    );
  }
}
