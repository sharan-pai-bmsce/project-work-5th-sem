import 'package:flutter/foundation.dart';
import 'package:fix_my_life/moduls/task.dart';
import 'package:fix_my_life/reposi/repository.dart';

class TaskService {
  Repository? _repository;

  TaskService() {
    _repository = Repository();
  }
  //Create data
  saveTask(Task task) async {
    return await _repository!.insertData('tasks', task.taskMap());
  }

  readTasks() async {
    return await _repository!.readData('tasks');
  }

  // read data from table by id
  readCategoryById(taskID) async {
    return await _repository!.readDataById('tasks', taskID);
  }

  //
  updateTask(Task task) async {
    return await _repository!.updateData('tasks', task.taskMap());
  }

  deleteTask(taskId) async {
    return await _repository!.deleteData('tasks', taskId);
  }
}
