import 'dart:convert';

import 'package:fix_my_life/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fix_my_life/moduls/task.dart';
// import 'package:fix_my_life/service/task_service.dart';

class TimeList extends StatefulWidget {
  const TimeList({Key? key}) : super(key: key);

  @override
  _TimeListState createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  var _taskNameController = TextEditingController();
  var _taskDescriptionController = TextEditingController();
  var _taskPriorityController = TextEditingController();
  var _taskDurationController = TextEditingController();

  int limit = 0;
  List<dynamic> time = [];

  var _edittaskNameController = TextEditingController();
  var _edittaskDescriptionController = TextEditingController();
  var _edittaskPriorityController = TextEditingController();
  var _edittasDurationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Utility.readFromTime().then((contents) {
      print(contents);
      if (contents != null) {
        time = contents;
      }
      setState(() {});
    });
    // getAllTasks();
  }

  // final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  // getAllTasks() async {
  //   var time = await _taskService.readTasks();
  //   time.forEach((task) {
  //     setState(() {
  //       var taskModel = Task();
  //       taskModel.name = task['name'];
  //       taskModel.description = task['description'];
  //       taskModel.id = task['id'];
  //       taskModel.priority = task['priority'];
  //       taskModel.duration = task['duration'];
  //       _taskList.add(taskModel);
  //     });
  //   });
  // }

  _editTask(BuildContext context, startTime) async {
    Map<String, dynamic> etask =
        time.firstWhere((element) => element["startTime"] == startTime);
    setState(() {
      _edittaskNameController.text = etask['name'] ?? 'No Name';
      _edittaskDescriptionController.text = etask['notes'] ?? 'No Description';
      _edittaskPriorityController.text = etask['priority'].toString();
      _edittasDurationController.text = etask['time'].toString();
    });
    _showEditDialog(context, etask);
  }

  _showFormDialog(BuildContext context) {
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
                    // _task.name = _taskNameController.text;
                    // _task.description = _taskDescriptionController.text;
                    // _task.priority = int.parse(_taskPriorityController.text);
                    // _task.duration = int.parse(_taskDurationController.text);

                    // var result = _taskService.saveTask(_task);

                    // print(await result);
                    // Navigator.pop(context);
                    // getAllTasks();

                    _showSuccessSnackBar(context, Text('Added Successfully'));
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
  }

  _showEditDialog(BuildContext context, task) {
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
                    task["name"] = _edittaskNameController.text;
                    task["notes"] = _edittaskDescriptionController.text;
                    task['priority'] =
                        int.parse(_edittaskPriorityController.text);
                    task['time'] = int.parse(_edittasDurationController.text);
                    dynamic etask =
                        await Utility.findByNameTimeTable(task["name"]);
                    print(await etask);
                    if (await etask == null) {
                      Utility.editTask(task).then((content) {
                        time = content["Tasks"];
                        limit = content["limit"];
                        setState(() {});
                      });
                    } else {
                      Utility.editTask(task).then((content) {
                        time = content["Tasks"];
                        limit = content["limit"];
                        if (limit <= 0) {
                          Utility.readFromTime().then((time) {
                            time = time as List<dynamic>;
                            Utility.generateTimetable();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent[50],
                              content: Text(
                                'Cannot accommodate task. Add time and then generate timetable.',
                                style: TextStyle(color: Colors.redAccent),
                              )));
                          setState(() {});
                        }
                        setState(() {});
                      });
                    }
                    Navigator.pop(context);
                    _showSuccessSnackBar(context, Text('Updated Successfully'));
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

  _showDeleteDialog(BuildContext context, startTime) {
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
                    dynamic dtime = time.firstWhere(
                        (element) => element["startTime"] == startTime);
                    print(await dtime);
                    if (await dtime != null) {
                      Utility.deleteTime(null, dtime).then((content) {
                        time = content;
                        setState(() {});
                      });
                    } else {
                      // Utility.deleteTask(dtask, "").then((content) {
                      //   time = content["Tasks"];
                      //   limit = content["limit"];
                      //   setState(() {});
                      // });
                      // Utility.deleteTimeTable(dtask);
                    }
                    Navigator.pop(context);
                    _showSuccessSnackBar(context, Text('Deleted Successfully'));
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

  _showSuccessSnackBar(context, message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    // _globalKey.currentState!.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // key: _globalKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, time);
            }),
        title: Text(
          "Time List",
          style: TextStyle(color: Colors.grey[400]),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView.builder(
          itemCount: time.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                color: Colors.grey[850],
                elevation: 8.0,
                child: ListTile(
                  // leading: IconButton(
                  //   icon: Icon(
                  //     Icons.edit,
                  //     color: Colors.blue,
                  //   ),
                  //   onPressed: () {
                  //     _editTask(context, time[index]["startTime"]);
                  //   },
                  // ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        time[index]["date"] +
                            ": " +
                            time[index]["startTime"] +
                            "-" +
                            time[index]["endTime"],
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      IconButton(
                          onPressed: () {
                            _showDeleteDialog(
                                context, time[index]["startTime"]);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                  // subtitle: Text(
                  //   time[index]["notes"],
                  //   style: TextStyle(color: Colors.grey[400]),
                  // ),
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
