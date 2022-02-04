import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fix_my_life/moduls/task.dart';
import 'package:fix_my_life/service/task_service.dart';
import '../utility.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskNameController = TextEditingController();
  var _taskDescriptionController = TextEditingController();
  var _taskPriorityController = TextEditingController();
  var _taskDurationController = TextEditingController();

  var _task = Task();
  var _taskService = TaskService();

  List<Task> _taskList = [];

  var etask;
  int limit = 0;
  var _edittaskNameController = TextEditingController();
  var _edittaskDescriptionController = TextEditingController();
  var _edittaskPriorityController = TextEditingController();
  var _edittasDurationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getAllTasks();
    Utility.localFile1.then((file) {
      file.exists().then((stat) {
        if (stat) {
          file.readAsString().then((contents) {
            Map<String, dynamic> content = jsonDecode(contents);
            limit = content["limit"];
            // tasks = content["Tasks"];
            print(content);
            print(limit);
            // setState(() {});
          });
        }
      });
    });
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllTasks() async {
    _taskList = [];
    var tasks = await _taskService.readTasks();
    tasks.forEach((task) {
      setState(() {
        var taskModel = Task();
        taskModel.name = task['name'];
        taskModel.description = task['description'];
        taskModel.id = task['id'];
        taskModel.priority = task['priority'];
        taskModel.duration = task['duration'];
        _taskList.add(taskModel);
      });
    });
  }

  _editTask(BuildContext context, taskID) async {
    etask = await _taskService.readCategoryById(taskID);
    limit -= await etask[0]['duration'] as int;
    setState(() {
      _edittaskNameController.text = etask[0]['name'] ?? 'No Name';
      _edittaskDescriptionController.text =
          etask[0]['description'] ?? 'No Description';
      _edittaskPriorityController.text = etask[0]['priority'].toString();
      _edittasDurationController.text = etask[0]['duration'].toString();
      print("Before Edit: " + limit.toString());
    });
    _showEditDialog(context);
  }

  /*_showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    _task.name = _taskNameController.text;
                    _task.description = _taskDescriptionController.text;
                    _task.priority = int.parse(_taskPriorityController.text);
                    _task.duration = int.parse(_taskDurationController.text);

                    var result = _taskService.saveTask(_task);

                    print(await result);
                    Navigator.pop(context);
                    getAllTasks();

                    _showSuccessSnackBar(Text('Added Successfully'));
                  },
                  child: Text('Save')),
            ],
            title: Text('Enter Task'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _taskNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a Task', labelText: 'Task Name'),
                  ),
                  TextField(
                    controller: _taskDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a Description',
                        labelText: 'Description'),
                  ),
                  TextField(
                    controller: _taskPriorityController,
                    decoration: InputDecoration(
                        hintText: 'Give a Priority', labelText: 'Priority'),
                  ),
                  TextField(
                    controller: _taskDurationController,
                    decoration: InputDecoration(
                        hintText: 'Give a Duration', labelText: 'Duration'),
                  )
                ],
              ),
            ),
          );
        });
  }*/

  limitUpdate() {
    Utility.localFile1.then((file) {
      print(limit);
      file.writeAsString(jsonEncode({"limit": limit}),
          mode: FileMode.writeOnly);
    });
  }

  _showEditDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: <Widget>[
              FlatButton(
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    _task.id = etask[0]['id'];
                    _task.name = _edittaskNameController.text;
                    _task.description = _edittaskDescriptionController.text;
                    _task.priority =
                        int.parse(_edittaskPriorityController.text);
                    _task.duration = int.parse(_edittasDurationController.text);
                    var result = _taskService.updateTask(_task);
                    limit += _task.duration;
                    //print(await result);
                    print("After Edit: " + limit.toString());
                    Navigator.pop(context);
                    getAllTasks();
                    limitUpdate();
                    _showSuccessSnackBar(Text('Updated Successfully'));
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            title: Text(
              'Edit Task',
              style: TextStyle(color: Colors.grey[400]),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _edittaskNameController,
                    style: TextStyle(color: Colors.grey[400]),
                    decoration: InputDecoration(
                        hintText: 'Write a Task',
                        labelText: 'Task Name',
                        labelStyle: TextStyle(color: Colors.grey[400])),
                  ),
                  TextField(
                    controller: _edittaskDescriptionController,
                    style: TextStyle(color: Colors.grey[400]),
                    decoration: InputDecoration(
                        hintText: 'Write a Description',
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.grey[400])),
                  ),
                  TextField(
                    controller: _edittaskPriorityController,
                    style: TextStyle(color: Colors.grey[400]),
                    decoration: InputDecoration(
                        hintText: 'Write a Priority',
                        labelText: 'Priority',
                        labelStyle: TextStyle(color: Colors.grey[400])),
                  ),
                  TextField(
                    controller: _edittasDurationController,
                    style: TextStyle(color: Colors.grey[400]),
                    decoration: InputDecoration(
                        hintText: 'Write a Duration',
                        labelText: 'Duration(in mins)',
                        labelStyle: TextStyle(color: Colors.grey[400])),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showDeleteDialog(BuildContext context, taskId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: <Widget>[
              FlatButton(
                  color: Colors.green,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[350]),
                  )),
              FlatButton(
                  color: Colors.red,
                  onPressed: () async {
                    etask = await _taskService.readCategoryById(taskId);
                    var result = _taskService.deleteTask(taskId);
                    limit -= await etask[0]['duration'] as int;
                    // print(await result);
                    print("After Delete: " + limit.toString());
                    Navigator.pop(context);
                    setState(() {
                      getAllTasks();
                      limitUpdate();
                    });
                    _showSuccessSnackBar(Text('Deleted Successfully'));
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.grey[350]),
                  )),
            ],
            title: Text('Are you sure you want to delete this?',
                style: TextStyle(color: Colors.grey[400])),
          );
        });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState!.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      key: _globalKey,
      appBar: AppBar(
        title: Text(
          "Task List",
          style: TextStyle(color: Colors.grey[400]),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView.builder(
          itemCount: _taskList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                color: Colors.grey[850],
                elevation: 8.0,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _editTask(context, _taskList[index].id);
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _taskList[index].name,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      IconButton(
                          onPressed: () {
                            _showDeleteDialog(context, _taskList[index].id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                  subtitle: Text(
                    _taskList[index].description,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
            );
          }),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.grey[850],
      //   onPressed: () {
      //     _showFormDialog(context);
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.grey[400],
      //   ),
      // ),
    );
  }
}
