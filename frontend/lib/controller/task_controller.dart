import 'package:async/async.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/service/task_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  final TaskService _taskService = Get.find();

  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoadingTasks = false.obs;
  CancelableOperation<void> loadTasksOperation;

final RxList<Task> newTasks = <Task>[].obs;
final RxList<Task> doneTasks = <Task>[].obs;

final RxList<Task> toDoTasks = <Task>[].obs;
final RxList<Task> inProgress = <Task>[].obs;
final RxList<Task> reviewTasks = <Task>[].obs;
final RxList<Task> todayTasks = <Task>[].obs;

void getNewTasks(Project project){
  isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      newTasks.clear();
      newTasks.addAll(fetchedTasks.where((Task element) => element.status != Status.done));
    });

}

void getTodayTasks(Project project){
  isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      todayTasks.clear();
      todayTasks.addAll(
        fetchedTasks.where(
          (Task element) => 
          element.status != Status.done &&
          DateFormat('dd.MM.yyyy').format(element.deadline) == DateFormat('dd.MM.yyyy').format(DateTime.now())
          )
          );
    });

}

void getDoneTasks(Project project){
  isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      doneTasks.clear();
      doneTasks.addAll(fetchedTasks.where((Task element) => element.status == Status.done));
    });

}

void getToDoTasks(Project project){
  isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      toDoTasks.clear();
      toDoTasks.addAll(fetchedTasks.where((Task element) => element.status == Status.todo));
    });

}

void getInProgress(Project project){
  isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      inProgress.clear();
      inProgress.addAll(fetchedTasks.where((Task element) => element.status == Status.inProgress));
    });

}

void getReviewTasks(Project project){
  isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      reviewTasks.clear();
      reviewTasks.addAll(fetchedTasks.where((Task element) => element.status == Status.review));
    });

}

  void refreshTasks(Project project) {
    getNewTasks(project);
    getDoneTasks(project);
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
   if (status == Status.todo) {
      toDoTasks.add(task.rebuild((TaskBuilder b) => b..status = status));
       newTasks.removeWhere((Task element) => element.taskId == task.taskId);
      inProgress.removeWhere((Task element) => element.taskId == task.taskId);
      reviewTasks.removeWhere((Task element) => element.taskId == task.taskId);
   } else if (status == Status.review) {
      reviewTasks.add(task.rebuild((TaskBuilder b) => b..status = status));
       newTasks.removeWhere((Task element) => element.taskId == task.taskId);
       toDoTasks.removeWhere((Task element) => element.taskId == task.taskId);
        inProgress.removeWhere((Task element) => element.taskId == task.taskId);
       
   } else if (status == Status.inProgress) {
      inProgress.add(task.rebuild((TaskBuilder b) => b..status = status));
       newTasks.removeWhere((Task element) => element.taskId == task.taskId);
       toDoTasks.removeWhere((Task element) => element.taskId == task.taskId);
      
         reviewTasks.removeWhere((Task element) => element.taskId == task.taskId);
   }

   if (status != Status.done) {
      doneTasks.removeWhere((Task element) => element.taskId == task.taskId);
      newTasks.removeWhere((Task element) => element.taskId == task.taskId);
      newTasks.add(task.rebuild((TaskBuilder b) => b..status = status));
    } else if (status == Status.done) {
      newTasks.removeWhere((Task element) => element.taskId == task.taskId);
       toDoTasks.removeWhere((Task element) => element.taskId == task.taskId);
        inProgress.removeWhere((Task element) => element.taskId == task.taskId);
         reviewTasks.removeWhere((Task element) => element.taskId == task.taskId);
      doneTasks.add(task.rebuild((TaskBuilder b) => b..status = status));
    }
  }

  void deleteTask(int taskId) {
    _taskService.deleteTask(taskId);
    tasks.removeWhere((Task element) => element.taskId == taskId);
    newTasks.removeWhere((Task element) => element.taskId == taskId);
    doneTasks.removeWhere((Task element) => element.taskId == taskId);
    toDoTasks.removeWhere((Task element) => element.taskId == taskId);
    inProgress.removeWhere((Task element) => element.taskId == taskId);
    reviewTasks.removeWhere((Task element) => element.taskId == taskId);
  }
}
