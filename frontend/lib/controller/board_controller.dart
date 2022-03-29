import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/ui/pages/board_page.dart';
import 'package:beebusy_app/ui/pages/profile_page.dart';
import 'package:beebusy_app/ui/pages/settings_page.dart';
import 'package:get/get.dart';

class BoardController extends GetxController {
  final AuthController _authController = Get.find();
  final TaskController _taskController = Get.find();
  final ProjectService _projectService = Get.find();

  final RxList<Project> _allUserProjects = <Project>[].obs;
  final RxList<Project> activeUserProjects = <Project>[].obs;
  final Rx<Project> selectedProject = Project().obs;
  final RxBool isLoadingUserProjects = true.obs;

  RxList<Task> get tasks => _taskController.tasks;
  RxList<Task> get newTasks => _taskController.newTasks;
  RxList<Task> get doneTasks => _taskController.doneTasks;


  List<Task> foundTasks = [];
  RxBool toggleVisibility = false.obs;


  final RxString currentRoute = BoardPage.route.obs;

  int tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    foundTasks = tasks;

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

    ever(
      selectedProject,
      _taskController.getNewTasks,
      condition: () => selectedProject.value.projectId != null,
    );

    ever(
      selectedProject,
      _taskController.getDoneTasks,
      condition: () => selectedProject.value.projectId != null,
    );
  }

  @override
  void onReady() {
    super.onReady();
    refreshUserProjects();
  }



  void filterTasks(String query) {
     List<Task> filteredTasks = [];
     if(query.isEmpty) {
       filteredTasks = tasks;
     } else {
       filteredTasks = tasks.where((Task task) => task.title.toLowerCase().contains(query.toLowerCase())).toList();

        foundTasks = filteredTasks;
        update();
     }
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

  void selectProfile() {
    currentRoute.value = ProfilePage.route;
    Get.toNamed<void>(ProfilePage.route);
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
