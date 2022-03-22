import 'package:async/async.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/service/task_service.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final TaskService _taskService = Get.find();

  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoadingTasks = false.obs;
  CancelableOperation<void> loadTasksOperation;

final RxList<Task> newTasks = <Task>[].obs;

void getNewTasks(Project project){
  isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      newTasks.clear();
      newTasks.addAll(fetchedTasks.where((Task element) => element.status == Status.todo));
    });

}

  void refreshTasks(Project project) {
    getNewTasks(project);
    isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      tasks.clear();
      tasks.addAll(fetchedTasks);
    });
  }

  void updateStatus(Task task, Status status) {
    _taskService.updateTask(taskId: task.taskId, status: status);
    tasks.removeWhere((Task element) => element.taskId == task.taskId);
    tasks.add(task.rebuild((TaskBuilder b) => b..status = status));
    newTasks.removeWhere((Task element) => element.taskId == task.taskId && element.status == Status.todo);
  }

  void deleteTask(int taskId) {
    _taskService.deleteTask(taskId);
    tasks.removeWhere((Task element) => element.taskId == taskId);
    newTasks.removeWhere((Task element) => element.taskId == taskId && element.status == Status.todo);
  }
}
