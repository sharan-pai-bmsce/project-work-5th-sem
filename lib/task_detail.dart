// ignore_for_file: file_names

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'task_body.dart';

class TaskDetail extends StatefulWidget {
  Map<String, dynamic> tasks = {};
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
    timLabel = time(widget.tasks["startTime"]);
    tim = timeLeft(widget.tasks["startTime"], widget.tasks["endTime"]);
    // if (mounted) {
    // _time = Timer.periodic(Duration(minutes: 1), (timer) {
    //   timLabel = time(widget.tasks["startTime"]);
    //   tim = timeLeft(widget.tasks["startTime"], widget.tasks["endTime"]);
    // });
    // }
    super.initState();
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
        title: Text(widget.tasks["name"],
            style: TextStyle(
                fontFamily: 'Brush',
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[850],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              widget.tasks["isComplete"];
            },
          )
        ],
        // foregroundColor: widget.tasks["color"],
      ),
      backgroundColor: Colors.grey[850],
      body: Container(
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
                    widget.tasks["notes"],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Divider(height: 30),
              ListTile(
                  leading: Icon(Icons.analytics_outlined, color: Colors.white),
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
                    widget.tasks["priority"].toString(),
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
                    (widget.tasks["startTime"].hour > 12
                                ? widget.tasks["startTime"].hour - 12
                                : widget.tasks["startTime"].hour == 0
                                    ? 12
                                    : widget.tasks["startTime"].hour)
                            .toString() +
                        ":" +
                        widget.tasks["startTime"].minute.toString() +
                        " " +
                        (widget.tasks["startTime"].hour < 12 ? "AM" : "PM"),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Divider(height: 30),
              ListTile(
                  leading: Icon(Icons.alarm_on_rounded, color: Colors.white),
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
                    (widget.tasks["endTime"].hour > 12
                                ? widget.tasks["endTime"].hour - 12
                                : widget.tasks["endTime"].hour == 0
                                    ? 12
                                    : widget.tasks["endTime"].hour)
                            .toString() +
                        ":" +
                        widget.tasks["endTime"].minute.toString() +
                        " " +
                        (widget.tasks["endTime"].hour < 12 ? "AM" : "PM"),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Divider(height: 30),
              ListTile(
                  leading: Icon(Icons.alarm_on_rounded, color: Colors.white),
                  title: Text(
                    timLabel ? "Task will start in:" : "Time left:",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  subtitle: Text(
                    tim + " mins",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ],
          )),
    );
  }
}

/*class TaskDetail extends StatelessWidget {
  Map<String, dynamic> tasks = {};
  TaskDetail({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(tasks);
    return Scaffold(
      appBar: AppBar(
        title: Text(tasks["name"],
            style: TextStyle(
                fontFamily: 'Brush',
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[850],
        elevation: 0,

        // foregroundColor: tasks["color"],
      ),
      backgroundColor: Colors.grey[850],
      body: Container(
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
                    tasks["notes"],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Divider(height: 30),
              ListTile(
                  leading: Icon(Icons.analytics_outlined, color: Colors.white),
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
                    tasks["priority"].toString(),
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
                    (tasks["startTime"].hour > 12
                                ? tasks["startTime"].hour - 12
                                : tasks["startTime"].hour == 0
                                    ? 12
                                    : tasks["startTime"].hour)
                            .toString() +
                        ":" +
                        tasks["startTime"].minute.toString() +
                        " " +
                        (tasks["startTime"].hour < 12 ? "AM" : "PM"),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Divider(height: 30),
              ListTile(
                  leading: Icon(Icons.alarm_on_rounded, color: Colors.white),
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
                    (tasks["endTime"].hour > 12
                                ? tasks["endTime"].hour - 12
                                : tasks["endTime"].hour == 0
                                    ? 12
                                    : tasks["endTime"].hour)
                            .toString() +
                        ":" +
                        tasks["endTime"].minute.toString() +
                        " " +
                        (tasks["endTime"].hour < 12 ? "AM" : "PM"),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Divider(height: 30),
              ListTile(
                  leading: Icon(Icons.alarm_on_rounded, color: Colors.white),
                  title: Text(
                    time(tasks['startTime'])
                        ? "Task will start in:"
                        : "Time left:",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  subtitle: Text(
                    timeLeft(tasks["startTime"], tasks["endTime"]) + " mins",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ],
          )),
    );
  }
}
*/
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
