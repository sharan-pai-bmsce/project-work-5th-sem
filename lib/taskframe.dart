import 'dart:convert';
import 'dart:math';

import 'package:fix_my_life/task_body.dart';
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
  int limit = 0;
  String name = "";
  String note = "";
  List<dynamic> tasks = [];
  int pri = 0, time = 0;
  TextEditingController priorityController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();

  // List<Map<String, dynamic>> tasks = [];
  final List<Color> _colorCollection = <Color>[];

  String minConverter(Duration? time) {
    // if (time == null) return "Approx. time to complete";
    // if (time.inMinutes > limit) {
    //   return "-1";
    // }
    return time!.inMinutes.toString() + " minutes";
  }

  @override
  void initState() {
    super.initState();
    Utility.localFile1.then((file) {
      file.exists().then((stat) {
        if (stat) {
          file.readAsString().then((contents) {
            Map<String, dynamic> content = jsonDecode(contents);
            limit = content["limit"];
            tasks = content["Tasks"];
            print(content);
            // setState(() {});
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: const Text("Task Manager"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list_alt),
              onPressed: () {},
            )
          ],
          elevation: 0,
        ),
        body: Container(
            decoration: BoxDecoration(
                // boxShadow: ,
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                  topRight: Radius.circular(70),
                )),
            child: SingleChildScrollView(
                child: Column(children: [
              // Container(
              //     padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              //     margin: EdgeInsets.fromLTRB(30, 30, 30, 5),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //       color: Colors.grey[700],
              //     ),
              //     child: Row(
              //       children: <Widget>[
              //         Text("Time Remaining: ",
              //             style: TextStyle(fontSize: 20, color: Colors.white)),
              //         Text(convert(limit),
              //             style: TextStyle(fontSize: 20, color: Colors.white)),
              //       ],
              //     )),
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
                            hintText: "Task Title",
                            hintStyle: TextStyle(color: Colors.white),
                          )),
                    ),
                    Divider(height: 40),
                    ListTile(
                        leading: Icon(Icons.low_priority_rounded,
                            color: Colors.white),
                        title: TextField(
                            controller: priorityController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Task Priority",
                              hintStyle: TextStyle(color: Colors.white),
                            ))),
                    Divider(height: 40),
                    ListTile(
                      leading: Icon(Icons.timelapse, color: Colors.white),
                      title: Builder(
                          builder: (BuildContext context) => TextButton(
                              onPressed: () async {
                                var resultingDuration =
                                    await showDurationPicker(
                                  context: context,
                                  initialTime: Duration(minutes: 30),
                                );
                                String val = minConverter(resultingDuration);
                                // if (val == "-1") {
                                //   ScaffoldMessenger.of(context)
                                //       .showSnackBar(SnackBar(
                                //           content: Text(
                                //     'Choose duration crosses the limit',
                                //     style: TextStyle(color: Colors.redAccent),
                                //   )));
                                //   _time = "Approx. time to complete";
                                // } else {
                                _time = val;
                                // }
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
                    ListTile(
                      leading: Icon(Icons.note_add, color: Colors.white),
                      title: TextField(
                          controller: noteController,
                          style: TextStyle(color: Colors.white),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Note",
                            hintStyle: TextStyle(color: Colors.white),
                          )),
                    ),
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
                        _getColorCollection();
                        List<dynamic> ttData = [];
                        if (tasks.length <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent[50],
                              content: Text(
                                'No tasks added to generate timetable',
                                style: TextStyle(color: Colors.redAccent),
                              )));
                          setState(() {});
                          return;
                        }

                        DateTime dateN = DateTime.now();
                        String date = dateN.day.toString() +
                            "-" +
                            dateN.month.toString() +
                            "-" +
                            dateN.year.toString();

                        Map<String, dynamic> res = {
                          "limit": limit,
                          "Tasks": tasks,
                        };
                        // tasks.sort((a, b) {
                        //   if (a["priority"] < b["priority"]) {
                        //     return 1;
                        //   } else if (a["priority"] == b["priority"]) {
                        //     if (a["time"] > b["time"]) {
                        //       return 1;
                        //     } else {
                        //       return 0;
                        //     }
                        //   }
                        //   return 0;
                        // });

                        // DateTime x = DateTime.now();
                        // DateTime start =
                        //     DateTime(x.year, x.month, x.day, 12, 30);
                        // Random random = new Random();
                        // for (var element in tasks) {
                        //   ttData.add({
                        //     "name": element["name"],
                        //     "startTime": start.toString(),
                        //     "endTime": start
                        //         .add(Duration(minutes: element["time"]))
                        //         .toString(),
                        //     "priority": element["priority"],
                        //     "notes": element["notes"],
                        //     "color": _colorCollection[random.nextInt(9)].value,
                        //     "complete": false,
                        //   });
                        //   start = start.add(Duration(minutes: element["time"]));
                        // }
                        // Map<String, dynamic> y = {
                        //   "Completed": [],
                        //   "Tasks": ttData,
                        // };

                        Utility.localFile1.then((file) {
                          file.writeAsString(jsonEncode(res),
                              mode: FileMode.writeOnly);
                          file.readAsString().then((content) => print(content));
                        });

                        // Utility.localFile2.then((file) {
                        //   file.writeAsString(jsonEncode(y),
                        //       mode: FileMode.writeOnly);

                        //   file.readAsString().then((content) => print(content));
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
                          time =
                              int.parse(_time.substring(0, _time.indexOf(' ')));
                          print(pri);
                          print(time);
                          limit += time;
                          note = noteController.text;
                          Map<String, dynamic> x = {
                            "name": name,
                            "time": time,
                            "priority": pri,
                            "notes": note == "" ? "No note was added" : note,
                          };
                          tasks.add(x);
                          titleController.clear();
                          priorityController.clear();
                          noteController.clear();
                          _time = 'Approx time to complete';
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.greenAccent[50],
                              content: Text(
                                'Task added Successfully',
                                style: TextStyle(color: Colors.greenAccent),
                              )));
                          setState(() {});
                        },
                        child: Text("Add Task",
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[700]),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 0)))))
              ]),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50))
            ]))));
  }

  void _getColorCollection() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Your timetable is ready'),
          ));
}

String convert(int time) {
  int min = (time % 60);
  int hour = ((time - min) / 60).floor();
  String hs = hour < 9 ? "0" + hour.toString() : hour.toString();
  String ms = min < 9 ? "0" + min.toString() : min.toString();
  return hs + " : " + ms;
}
