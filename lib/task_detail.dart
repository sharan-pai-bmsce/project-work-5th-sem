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
  int timLabel = 3;
  @override
  void initState() {
    timLabel = time(widget.tasks.startTime, widget.tasks.endTime);
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
                    Map<String, dynamic> tasks = {
                      "name": widget.tasks.subject,
                      "startTime": widget.tasks.startTime.toString(),
                      "endTime": widget.tasks.endTime.toString(),
                    };
                    setState(() {
                      Utility.deleteTask(tasks, "");
                      Utility.deleteTimeTable(tasks);
                    });
                    Navigator.pop(context);
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
                        (widget.tasks.startTime.hour < 10 ? "0" : "") +
                            widget.tasks.startTime.hour.toString() +
                            ":" +
                            (widget.tasks.startTime.minute < 10 ? "0" : "") +
                            widget.tasks.startTime.minute.toString(),
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
                        (widget.tasks.endTime.hour < 10 ? "0" : "") +
                            widget.tasks.endTime.hour.toString() +
                            ":" +
                            (widget.tasks.endTime.minute < 10 ? "0" : "") +
                            widget.tasks.endTime.minute.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  Divider(height: 30),
                  ListTile(
                      leading: Icon(Icons.access_alarms_outlined,
                          color: Colors.white),
                      title: Text(
                        "Duration:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      subtitle: Text(
                        widget.tasks.endTime
                                .difference(widget.tasks.startTime)
                                .inMinutes
                                .toString() +
                            " mins",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  Divider(height: 30),
                  !widget.tasks.isComplete &&
                          DateTime.now().compareTo(widget.tasks.endTime) < 0
                      ? ListTile(
                          leading:
                              Icon(Icons.alarm_on_rounded, color: Colors.white),
                          title: Text(
                            timLabel == 1
                                ? "Task will start in:"
                                : timLabel == 2
                                    ? "Time left:"
                                    : "",
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

int time(DateTime start, DateTime end) {
  if (DateTime.now().compareTo(start) < 0) {
    return 1;
  } else if (DateTime.now().compareTo(end) < 0) {
    return 2;
  }
  return 0;
}

String timeLeft(DateTime start, DateTime end) {
  DateTime d = DateTime.now();
  if (DateTime.now().compareTo(start) < 0) {
    return start.difference(DateTime.now()).inMinutes.toString();
  } else if (DateTime.now().compareTo(end) < 0) {
    return end.difference(DateTime.now()).inMinutes.toString();
  }
  return "";
}

DateTime diff(DateTime start) {
  if (start.compareTo(DateTime.now()) < 0) {
    return DateTime.now();
  }
  return start;
}
