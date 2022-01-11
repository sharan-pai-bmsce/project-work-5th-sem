import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'utility.dart';

class TaskFrame extends StatefulWidget {
  const TaskFrame({Key? key}) : super(key: key);

  @override
  _TaskFrameState createState() => _TaskFrameState();
}

class _TaskFrameState extends State<TaskFrame> {
  String _time = "Approx. time to complete";
  int limit = 120;
  String name = "";
  int pri = 0, time = 0;
  TextEditingController priorityController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();

  List<Map<String, dynamic>> tasks = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile1 async {
    final path = await _localPath;
    return File('$path/task-input.json');
  }

  String minConverter(Duration? time) {
    if (time == null) return "Approx. time to complete";
    if (time.inMinutes > limit) {
      return "-1";
    }
    return time.inMinutes.toString() + " minutes";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: const Text("Task Manager"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list_alt),
              onPressed: () {},
            )
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation(),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.grey[850],
        //   child: Text(
        //     "+",
        //     style: TextStyle(fontSize: 25),
        //   ),
        //   onPressed: () {},
        // ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              margin: EdgeInsets.fromLTRB(30, 20, 30, 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[700],
              ),
              child: Row(
                children: <Widget>[
                  Text("Time Remaining: ",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Text(convert(limit),
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              )),
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 40),
            margin: EdgeInsets.fromLTRB(30, 20, 30, 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[700],
            ),
            child: Column(
              children: <Widget>[
                Divider(height: 40),
                ListTile(
                  leading: Icon(Icons.title_rounded, color: Colors.white),
                  title: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.white),
                      )),
                ),
                Divider(height: 40),
                ListTile(
                    leading:
                        Icon(Icons.low_priority_rounded, color: Colors.white),
                    title: TextField(
                        controller: priorityController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Task Priority",
                          hintStyle: TextStyle(color: Colors.white),
                        ))),
                Divider(height: 40),
                // ListTile(
                //     leading: Icon(Icons.timelapse, color: Colors.white),
                //     title: TextField(
                //         decoration: InputDecoration(
                //       hintText: "Approx. time to finish",
                //       hintStyle: TextStyle(color: Colors.white),
                //     ))),
                ListTile(
                  leading: Icon(Icons.timelapse, color: Colors.white),
                  title: Builder(
                      builder: (BuildContext context) => TextButton(
                          onPressed: () async {
                            var resultingDuration = await showDurationPicker(
                              context: context,
                              initialTime: Duration(minutes: 30),
                            );
                            String val = minConverter(resultingDuration);
                            if (val == "-1") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                'Choose duration crosses the limit',
                                style: TextStyle(color: Colors.redAccent),
                              )));
                              _time = "Approx. time to complete";
                            } else {
                              _time = val;
                            }
                            setState(() {});
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _time,
                                style: TextStyle(color: Colors.white),
                              )))),
                ),
                Divider(height: 40),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                margin: EdgeInsets.fromLTRB(30, 0, 10, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[700],
                  ),
                  onPressed: () async {
                    // var file = await _localFile1;
                    DateTime dateN = DateTime.now();
                    String date = dateN.day.toString() +
                        "-" +
                        dateN.month.toString() +
                        "-" +
                        dateN.year.toString();
                    // int size = tasks.length;
                    // String res = "date: " + date + ",";
                    // res += "[";
                    // for (var element in tasks) {
                    //   res += element.toString();
                    // }
                    // res += "]";
                    Map<String, dynamic> res = {
                      "date": date,
                      "Tasks": tasks,
                    };
                    // file.writeAsString(jsonEncode(res),
                    // mode: FileMode.writeOnly);
                    tasks.sort((a, b) {
                      if (a["priority"] < b["priority"]) {
                        return 1;
                      } else if (a["priority"] == b["priority"]) {
                        if (a["time"] > b["time"]) {
                          return 1;
                        } else {
                          return 0;
                        }
                      }
                      return 0;
                    });
                    print(jsonEncode(res));
                    // file.readAsString().then((content) {
                    //   String date = content.substring(
                    //       content.indexOf("date: ") + 6, content.indexOf(","));

                    // });
                  },
                  child: const Text(
                    'Generate Timetable',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(10, 0, 30, 10),
                child: ElevatedButton(
                    onPressed: () async {
                      name = titleController.text;
                      if (name == "") {
                        titleController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.redAccent[50],
                            content: Text(
                              'Title Not entered properly',
                              style: TextStyle(color: Colors.redAccent),
                            )));
                        setState(() {});
                        return;
                      }
                      print(name);
                      if (!priorityController.text
                              .contains(RegExp('^[1-5]\$')) &&
                          priorityController.text.length != 1) {
                        priorityController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.redAccent[50],
                            content: Text(
                              'Priority Not entered properly',
                              style: TextStyle(color: Colors.redAccent),
                            )));
                        setState(() {});
                        return;
                      }
                      pri = int.parse(priorityController.text);
                      time = int.parse(_time.substring(0, _time.indexOf(' ')));
                      print(pri);
                      print(time);
                      limit -= time;
                      Map<String, dynamic> x = {
                        "name": name,
                        "time": time,
                        "priority": pri
                      };
                      tasks.add(x);
                      titleController.clear();
                      priorityController.clear();
                      _time = 'Approx time to complete';
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.greenAccent[50],
                          content: Text(
                            'Task added Successfully',
                            style: TextStyle(color: Colors.greenAccent),
                          )));
                      setState(() {});
                    },
                    child:
                        Text("Add Task", style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[700]),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: 50, vertical: 0)))))
          ])
        ])));
  }
}

String convert(int time) {
  int min = (time % 60);
  int hour = ((time - min) / 60).floor();
  String hs = hour < 9 ? "0" + hour.toString() : hour.toString();
  String ms = min < 9 ? "0" + min.toString() : min.toString();
  return hs + " : " + ms;
}
