// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'task_body.dart';
import 'utility.dart';

class TaskDetail extends StatefulWidget {
  Task tasks;
  TaskDetail({Key? key, required this.tasks}) : super(key: key);

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Timer? _time;
  String tim = "";
  bool timLabel = false;
  @override
  void initState() {
    timLabel = time(widget.tasks.startTime);
    tim = timeLeft(widget.tasks.startTime, widget.tasks.endTime);
    // Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
    // super.initState();
  }

  @override
  void dispose() {
    // _time!.cancel();
    // _time = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tasks.subject,
            style: TextStyle(
                fontFamily: 'Brush',
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[850],
        elevation: 0,
        actions: !widget.tasks.isComplete
            ? [
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    Utility.localFile2.then((file) {
                      file.exists().then((status) {
                        if (status) {
                          file.readAsString().then((content) {
                            Map<String, dynamic> object = jsonDecode(content);
                            List<dynamic> tasks = object["Tasks"];
                            tasks.removeWhere(
                                (task) => task["name"] == widget.tasks.subject);
                            List<dynamic> completed = object["Completed"];
                            var val = {
                              "name": widget.tasks.subject + " - Completed",
                              "priority": widget.tasks.priority,
                              "notes": widget.tasks.notes,
                              "color": Colors.green[300]!.value,
                              "startTime": widget.tasks.startTime.toString(),
                              "endTime": widget.tasks.endTime.toString(),
                              "complete": true,
                            };
                            completed.add(val);
                            object = {
                              "Completed": completed,
                              "Tasks": tasks,
                            };
                            file.writeAsString(jsonEncode(object),
                                mode: FileMode.writeOnly);
                            Navigator.pop(context);
                          });
                        }
                      });

                      Utility.localFile1.then((file) {
                        file.exists().then((status) {
                          if (status) {
                            file.readAsString().then((content) {
                              Map<String, dynamic> object = jsonDecode(content);
                              List<dynamic> tasks = object["Tasks"];
                              tasks.removeWhere((task) =>
                                  task["name"] == widget.tasks.subject);
                              file.writeAsString(jsonEncode(object),
                                  mode: FileMode.writeOnly);
                            });
                          }
                        });
                      });
                    });
                  },
                )
              ]
            : [],
        // foregroundColor: widget.tasks["color"],
      ),
      backgroundColor: Colors.grey[850],
      body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  // boxShadow: ,
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70),
                  )),
              child: Column(
                children: [
                  Divider(height: 30),
                  ListTile(
                      leading: Icon(Icons.notes, color: Colors.white),
                      title: Text(
                        "Notes:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      subtitle: Text(
                        widget.tasks.notes ?? "",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  Divider(height: 30),
                  ListTile(
                      leading:
                          Icon(Icons.analytics_outlined, color: Colors.white),
                      title: Text(
                        "Priority:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      subtitle: Text(
                        widget.tasks.priority.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  Divider(height: 30),
                  ListTile(
                      leading: Icon(Icons.alarm_add_sharp, color: Colors.white),
                      title: Text(
                        "Start Time:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      subtitle: Text(
                        (widget.tasks.startTime.hour > 12
                                    ? widget.tasks.startTime.hour - 12
                                    : widget.tasks.startTime.hour == 0
                                        ? 12
                                        : widget.tasks.startTime.hour)
                                .toString() +
                            ":" +
                            widget.tasks.startTime.minute.toString() +
                            " " +
                            (widget.tasks.startTime.hour < 12 ? "AM" : "PM"),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  Divider(height: 30),
                  ListTile(
                      leading:
                          Icon(Icons.alarm_on_rounded, color: Colors.white),
                      title: Text(
                        "End Time:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      subtitle: Text(
                        (widget.tasks.endTime.hour > 12
                                    ? widget.tasks.endTime.hour - 12
                                    : widget.tasks.endTime.hour == 0
                                        ? 12
                                        : widget.tasks.endTime.hour)
                                .toString() +
                            ":" +
                            widget.tasks.endTime.minute.toString() +
                            " " +
                            (widget.tasks.endTime.hour < 12 ? "AM" : "PM"),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  Divider(height: 30),
                  !widget.tasks.isComplete
                      ? ListTile(
                          leading:
                              Icon(Icons.alarm_on_rounded, color: Colors.white),
                          title: Text(
                            timLabel ? "Task will start in:" : "Time left:",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          subtitle: Text(
                            tim + " mins",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ))
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                        ),
                ],
              ))),
    );
  }
}

bool time(DateTime start) {
  return DateTime.now().compareTo(start) < 0;
}

String timeLeft(DateTime start, DateTime end) {
  DateTime d = DateTime.now();
  if (DateTime.now().compareTo(start) < 0) {
    return (Duration(hours: start.hour, minutes: start.minute) -
            Duration(hours: d.hour, minutes: d.minute))
        .inMinutes
        .toString();
  }
  Duration timeleft = (Duration(hours: end.hour, minutes: end.minute) -
      Duration(hours: d.hour, minutes: d.minute));
  return timeleft.inMinutes.toString();
}
