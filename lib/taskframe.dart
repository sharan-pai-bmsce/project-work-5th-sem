import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'utility.dart';

const todoList = "/todoList";

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

  final List<Color> _colorCollection = <Color>[];

  String minConverter(Duration? time) {
    if (time == null) return "Approx. time to complete";
    return time.inMinutes.toString() + " minutes";
  }

  @override
  void initState() {
    super.initState();
    Utility.readFromTask().then((contents) {
      print(contents);
      if (contents != null) {
        limit = contents["limit"];
        tasks = contents["Tasks"];
      }
      setState(() {});
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
              onPressed: () {
                Navigator.pushNamed(context, todoList).then((dynamic object) {
                  print(object);
                  if (object != null) {
                    tasks = object["Tasks"];
                    limit = object["limit"];
                  }
                  setState(() {});
                });
              },
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
                            keyboardType: TextInputType.number,
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
                                _time = val;
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
                            "notes": note == ""
                                ? "No note was added"
                                : note.toString(),
                          };
                          tasks.add(x);
                          titleController.clear();
                          priorityController.clear();
                          noteController.clear();
                          _time = 'Approx time to complete';
                          Map<String, dynamic> res = {
                            "limit": limit,
                            "Tasks": tasks,
                          };
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.greenAccent[50],
                              content: Text(
                                'Task added Successfully',
                                style: TextStyle(color: Colors.greenAccent),
                              )));
                          setState(() {});
                          Utility.writeIntoTask(res);
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
            ]))));
  }
}

String convert(int time) {
  int min = (time % 60);
  int hour = ((time - min) / 60).floor();
  String hs = hour < 9 ? "0" + hour.toString() : hour.toString();
  String ms = min < 9 ? "0" + min.toString() : min.toString();
  return hs + " : " + ms;
}
