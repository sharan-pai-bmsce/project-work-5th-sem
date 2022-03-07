import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'package:fix_my_life/taskframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'utility.dart';

const timeList = "/timeList";

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePicker createState() => _DateTimePicker();
}

class _DateTimePicker extends State<DateTimePicker> {
  String _date = "Not set";
  String timestart = "Not set";
  String timeend = "Not set";
  String message = "";
  DateTime ts = DateTime.now();
  DateTime td = DateTime.now();
  List<dynamic> time = [];
  List<dynamic> ttData = [];
  List<dynamic> tasks = [];
  Map<String, dynamic> fileContents = {};
  DateTime now = DateTime.now();
  int limit = 0;
  int type = 0;
  Widget _buildAboutText() {
    return new RichText(
        text: new TextSpan(
      text: message,
      style: const TextStyle(color: Colors.black87),
    ));
  }

  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: type == 0
          ? Text('Error!',
              style: TextStyle(color: Color(Colors.red[300]!.value)))
          : Text("Success!",
              style: TextStyle(color: Color(Colors.green[300]!.value))),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Okay, got it!'),
        ),
      ],
    );
  }

  Widget needed(BuildContext context, String mes, int type) {
    this.type = type;
    message = mes;
    return _buildAboutDialog(context);
  }

  @override
  void initState() {
    super.initState();
    Utility.readFromTask().then((contents) {
      if (contents != null) {
        limit = contents["limit"];
        tasks = contents["Tasks"];
      }
      setState(() {});
    });
    Utility.readFromTime().then((contents) {
      if (contents != null) time = contents;
      print(contents);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text('Fix My Life'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list_alt),
            onPressed: () {
              Navigator.pushNamed(context, timeList).then((dynamic object) {
                print(object);
                if (object != null) {
                  time = object;
                  Utility.readFromTask().then((val) {
                    if (val == null) return;
                    limit = val["limit"];
                    if (limit <= 0) {
                      Utility.generateTimetable();
                    } else {
                      Utility.writeIntoTimeTable([]);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent[50],
                          content: Text(
                            'Cannot accommodate tasks. Add time and then generate timetable.',
                            style: TextStyle(color: Colors.redAccent),
                          )));
                      setState(() {});
                    }
                    setState(() {});
                  });
                }
                setState(() {});
              });
            },
          )
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey[700],
                  ),
                  child: Row(
                    children: <Widget>[
                      (limit <= 0
                          ? Text("Extra Time Remaining: ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                          : Text("Time Remaining: ",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white))),
                      Text(limit > 0 ? convert(limit) : convert(-limit),
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                  )),
              Divider(height: 7),

              RaisedButton(
                color: Colors.grey[850],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(
                          now.year, now.month, now.day, now.hour, now.minute),
                      onConfirm: (date) {
                    print('confirm $date');
                    _date =
                        '${date.year}-${date.month < 10 ? "0" : ""}${date.month}-${date.day < 10 ? "0" : ""}${date.day}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  decoration: BoxDecoration(color: Colors.grey[850]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                // color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),

              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Start Time:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                  )),
              Divider(height: 7),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    if (_date == "Not set") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => needed(
                            context,
                            'Set the date before setting the start timer.\n\n',
                            0),
                      );
                      setState(() {});
                      return;
                    }
                    var d = DateTime.parse(_date.replaceAll(" ", "") +
                        " " +
                        (time.hour < 10 ? "0" : "") +
                        time.hour.toString() +
                        ":" +
                        (time.minute < 10 ? "0" : "") +
                        time.minute.toString() +
                        ":00");
                    if (timeend != "Not set" && time.isAfter(td)) {
                      print('end time $td greater than start');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => needed(
                            context,
                            'Free End time can\'t be greater than Start Time\n\n',
                            0),
                      );
                    } else if (d.isBefore(DateTime.now())) {
                      print("Time less than current time.");
                      timestart = "Not set";
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => needed(
                              context, "Entered time before current time.", 0)
                          // _buildAboutDialog(context),
                          );
                      setState(() {});
                    } else if ((timeend != "Not set" && time.isBefore(td)) ||
                        timeend == "Not set") {
                      print('confirm $time');
                      ts = time;
                      timestart =
                          '${(time.hour < 10 ? "0" : "")}${time.hour}:${(time.minute < 10 ? "0" : "")}${time.minute}';
                      setState(() {});
                    }
                  },
                      showSecondsColumn: false,
                      currentTime: DateTime.now(),
                      locale: LocaleType.en);
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $timestart",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.grey[850],
              ),
              //APPLYING CHANGE
              SizedBox(
                height: 20.0,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "End Time:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                  )),
              Divider(height: 7),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      showSecondsColumn: false,
                      //minTime: DateTime(ts.hour, ts.minute, ts.second),
                      onConfirm: (time) {
                    if (_date == "Not set") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => needed(
                            context,
                            'Set the date before setting the end timer.\n\n',
                            0),
                      );
                      setState(() {});
                      return;
                    }
                    // print(time);
                    var d = DateTime.parse(_date.replaceAll(" ", "") +
                        " " +
                        (time.hour < 10 ? "0" : "") +
                        time.hour.toString() +
                        ":" +
                        (time.minute < 10 ? "0" : "") +
                        time.minute.toString() +
                        ":00");
                    // print(d);
                    if (time.isBefore(ts) && timestart != "Not set") {
                      print('end time $time greater than start');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => needed(
                            context,
                            'Free End time can\'t be greater than Start Time\n\n',
                            0),
                      );
                    } else if (d.isBefore(DateTime.now())) {
                      print("Time less than current time.");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => needed(
                              context, "Entered time before current time.", 0)
                          // _buildAboutDialog(context),
                          );
                    } else {
                      print("confirm  $time");
                      timeend =
                          '${(time.hour < 10 ? "0" : "")}${time.hour}:${(time.minute < 10 ? "0" : "")}${time.minute}';
                      td = time;
                      setState(() {});
                    }
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $timeend",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.grey[850],
              ),
              Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text(
                      "Generate Timetable!",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (limit > 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => needed(
                                context,
                                "Cannot generate timetable. Add more time to generate timetable.",
                                0)
                            // _buildAboutDialog(context),
                            );
                        return;
                      }
                      if (tasks.length == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => needed(
                                context,
                                "Cannot generate timetable. Add tasks to generate timetable.",
                                0)
                            // _buildAboutDialog(context),
                            );
                        return;
                      }
                      Utility.generateTimetable().then((value) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => needed(
                                context, "Timetable successfully generated.", 1)
                            // _buildAboutDialog(context),
                            );
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.grey[850],
                    textColor: Colors.teal,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  RaisedButton(
                    child: Text(
                      "Add time",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (timestart == "Not set") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => needed(context,
                                "Cannot add time without start time!", 0)
                            // _buildAboutDialog(context),
                            );
                        print(limit);
                        setState(() {});
                        return;
                      }
                      if (timeend == "Not set") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => needed(
                                context, "Cannot add time without end time!", 0)
                            // _buildAboutDialog(context),
                            );
                        setState(() {});
                        return;
                      }
                      if (_date == "Not set") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => needed(
                                context, "Cannot add time without date!", 0)
                            // _buildAboutDialog(context),
                            );
                        setState(() {});
                        return;
                      }
                      int duration = DateTime.parse("$_date $timeend:00")
                          .difference(DateTime.parse("$_date $timestart:00"))
                          .inMinutes;
                      Map<String, dynamic> ele = {
                        "date": _date,
                        "startTime": timestart,
                        "endTime": timeend,
                        "duration": duration,
                      };
                      // print();
                      if (!containment(time, ele)) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                needed(context, "Time range already given!", 0)
                            // _buildAboutDialog(context),
                            );
                        timestart = "Not set";
                        timeend = "Not set";
                        setState(() {});
                        return;
                      }
                      time.add(ele);
                      _date = "Not set";
                      timestart = "Not set";
                      timeend = "Not set";
                      limit -= duration;
                      print(limit);
                      Utility.writeIntoTime(time);
                      Utility.writeIntoTask({
                        "limit": limit,
                        "Tasks": tasks,
                      });
                      setState(() {});
                      print(time);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.grey[850],
                    textColor: Colors.teal,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.grey,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String convert(int time) {
    int min = (time % 60);
    int hour = ((time - min) / 60).floor();
    String hs = hour < 9 ? "0" + hour.toString() : hour.toString();
    String ms = min < 9 ? "0" + min.toString() : min.toString();
    return hs + " : " + ms;
  }

  bool containment(List<dynamic> time, Map<String, dynamic> curr) {
    DateTime ts = DateTime.parse(curr["date"] + " " + curr["startTime"]);
    DateTime te = DateTime.parse(curr["date"] + " " + curr["endTime"]);
    bool k = false;
    for (var element in time) {
      DateTime elets =
          DateTime.parse(element["date"] + " " + element["startTime"]);
      DateTime elete =
          DateTime.parse(element["date"] + " " + element["endTime"]);
      if (!(te.isBefore(elets) || ts.isAfter(elete))) {
        return false;
      }
    }
    return true;
  }
}
