// ignore_for_file: await_only_futures

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:fix_my_life/task_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class Utility {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get localFileTask async {
    final path = await _localPath;
    return File('$path/task-input.json');
  }

  static Future<File> get localFileTimeTable async {
    final path = await _localPath;
    return File('$path/timetable.json');
  }

  static Future<File> get localFileTime async {
    final path = await _localPath;
    return File('$path/time_input.json');
  }

  static Future<dynamic> readFromTask() async {
    try {
      var file = await Utility.localFileTask;
      bool stat = await file.exists();
      if (await stat) {
        var content = file.readAsString();
        return jsonDecode(await content);
      }
    } catch (exception, stack) {
      print(exception);
      return {};
    }
    // return Utility.localFile1.then((file) {
    //   return file.readAsString();
    //   // file.exists().then((stat) {
    //   //   if (stat) {
    //   //     file.readAsString().then((contents) {
    //   //       return jsonDecode(contents);
    //   //       // setState(() {});
    //   //     });
    //   //   }
    //   // });
    // }).then((contents) {
    //   return jsonDecode(contents);
    //   // setState(() {});
    // }).catchError((err) {
    //   print(err);
    //   return [];
    // });
  }

  static Future<dynamic> readFromTime() async {
    try {
      var file = await Utility.localFileTime;
      bool stat = await file.exists();
      if (stat) {
        var content = file.readAsString();
        return jsonDecode(await content);
      }
    } catch (exception, stack) {
      print(exception);
      return {};
    }
  }

  static Future<dynamic> readFromTimeTable() async {
    try {
      var file = await Utility.localFileTimeTable;
      bool stat = await file.exists();
      if (await stat) {
        var content = file.readAsString();
        return jsonDecode(await content);
      }
    } catch (exception, stack) {
      print(exception);
      return {};
    }
  }

  static Future<dynamic> findByNameTimeTable(String name) async {
    dynamic ttData = await readFromTimeTable();
    List<dynamic> tt = [];
    if (ttData != null) {
      tt = ttData;
      if (tt.isNotEmpty)
        return tt.firstWhere((element) => element["name"] == name);
      else
        return null;
    }
  }

  static void writeIntoTask(Map<String, dynamic> res) {
    Utility.localFileTask.then((file) {
      file.writeAsString(jsonEncode(res), mode: FileMode.writeOnly);
    });
  }

  static void writeIntoTimeTable(List<dynamic> res) {
    Utility.localFileTimeTable.then((file) {
      file.writeAsString(jsonEncode(res), mode: FileMode.writeOnly);
    });
  }

  static void writeIntoTime(List<dynamic> res) {
    Utility.localFileTime.then((file) {
      file.writeAsString(jsonEncode(res), mode: FileMode.writeOnly);
    });
  }

  static Future<void> eliminatepreviousTime() async {
    dynamic timeContent = await Utility.readFromTime();
    dynamic taskContent = await Utility.readFromTask();
    List<dynamic> timeList = [];
    if (timeContent != null) timeList = timeContent;
    if (timeContent != null && taskContent != null) {
      DateTime curr = DateTime.now();
      // print(taskContent);
      print(timeContent);
      for (int i = 0; i < timeList.length; i++) {
        DateTime endtime = DateTime.parse(
            timeContent[i]["date"] + " " + timeContent[i]["endTime"] + ":00");
        DateTime starttime = DateTime.parse(
            timeContent[i]["date"] + " " + timeContent[i]["startTime"] + ":00");
        if (endtime.isBefore(curr)) {
          taskContent["limit"] += timeList[i]["duration"];
          timeList.remove(timeList[i]);
        } else if (starttime.isBefore(curr)) {
          timeContent[i]["startTime"] =
              (curr.hour < 10 ? curr.hour.toString() : curr.hour.toString()) +
                  ":" +
                  (curr.minute < 10
                      ? curr.minute.toString()
                      : curr.minute.toString());
          int x = timeContent[i]["duration"];
          timeContent[i]["duration"] = endtime.difference(curr).inMinutes;
          taskContent["limit"] += (x - timeContent[i]["duration"]);
        }
      }
      // print(taskContent);
      print(timeContent);
      Utility.writeIntoTime(timeList);
      Utility.writeIntoTask(
          {"limit": taskContent["limit"], "Tasks": taskContent["Tasks"]});
    }
  }

  static void eliminatepreviousTask() async {
    // dynamic tasksData = await Utility.readFromTask();
    dynamic ttData = await Utility.readFromTimeTable();
    List<dynamic> tasks = [], tt = [];
    // if (tasksData != null) tasks = tasksData["Tasks"];
    if (ttData != null) tt = ttData;
    if (ttData != null) {
      for (int i = 0; i < tt.length; i++) {
        DateTime startTime = DateTime.parse(tt[i]["startTime"]);
        DateTime endTime = DateTime.parse(tt[i]["endTime"]);
        if (endTime.isBefore(DateTime.now())) {
          // for (int j = 0; j < tasks.length; j++) {
          //   if (tasks[j]["name"] == tt[i]["name"]) {
          //     int k = endTime.difference(startTime).inMinutes;
          //     tasks[j]["time"] -= k;
          //     // tasksData["limit"] += k;
          //     // if (tasks[j]["time"] <= 0) {
          //     //   tasks.remove(tasks[j]);
          //     // }
          //     break;
          //   }
          // }
          tt.remove(tt[i]);
        }
        // Utility.writeIntoTask({"limit": tasksData["limit"], "Tasks": tasks});
        Utility.writeIntoTimeTable(tt);
      }
    }
  }

  static Future<dynamic> deleteTask(
      Map<String, dynamic>? task, String name) async {
    dynamic tasksData = await Utility.readFromTask();
    List<dynamic> tasks = [];
    int limit = 0;
    if (tasksData != null) {
      tasks = tasksData["Tasks"];
      limit = tasksData["limit"];
    }
    if (task != null) {
      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i]["name"] == task["name"]) {
          DateTime startTime = DateTime.parse(task["startTime"]);
          DateTime endTime = DateTime.parse(task["endTime"]);
          // tasks[i]["time"] += startTime.difference(endTime).inMinutes;
          tasks.remove(tasks[i]);
          // print(object["limit"]);
          int k = diff(startTime.isBefore(DateTime.now())
                  ? DateTime.now().add(Duration(minutes: 0))
                  : startTime)
              .difference(endTime)
              .inMinutes;
          print(k);
          limit += k;
          // print(object["limit"]);
          break;
        }
      }
    } else {
      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i]["name"] == name) {
          limit -= tasks[i]["time"] as int;
          tasks.remove(tasks[i]);
          break;
        }
      }
    }
    if (tasksData != null) {
      Utility.writeIntoTask({"limit": limit, "Tasks": tasks});
      return {"limit": limit, "Tasks": tasks};
    }
  }

  static Future<void> generateTimetable(
      List<dynamic> time, List<dynamic> tasks, int limit) async {
    List<dynamic> ttData = [];
    List<Color> _colorCollection = <Color>[
      Color(0xFF0F8644),
      Color(0xFF8B1FA9),
      Color(0xFFD20100),
      Color(0xFFFC571D),
      Color(0xFF36B37B),
      Color(0xFF01A1EF),
      Color(0xFF3D4FB5),
      Color(0xFFE47C73),
      Color(0xFF636363),
      Color(0xFF0A8043),
    ];

    time.sort((a, b) {
      if (DateTime.parse(a["date"] + " " + a["startTime"])
          .isBefore(DateTime.parse(b["date"] + " " + a["endTime"]))) {
        return -1;
      }
      return 1;
    });
    print(time);
    Random random = new Random();
    int trace = 0;
    int timeLeft = 0;
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
    for (int j = 0; j < time.length; j++) {
      DateTime start =
          DateTime.parse(time[j]["date"] + " " + time[j]["startTime"] + ":00");
      int duration = time[j]["duration"];
      print(duration);

      for (int i = trace; i < tasks.length; i++) {
        if (tasks[i]["time"] - timeLeft <= duration) {
          ttData.add({
            "name": tasks[i]["name"],
            "startTime": start.toString(),
            "endTime": start
                .add(Duration(minutes: tasks[i]["time"] - timeLeft))
                .toString(),
            "priority": tasks[i]["priority"],
            "notes": tasks[i]["notes"],
            "color": _colorCollection[random.nextInt(9)].value,
            "complete": false,
          });
          start = start.add(Duration(minutes: tasks[i]["time"] - timeLeft));
          duration = (duration + timeLeft - tasks[i]["time"]) as int;
          trace = i + 1;
          timeLeft = 0;
          // tasks.remove(tasks[i]);
        } else {
          ttData.add({
            "name": tasks[i]["name"],
            "startTime": start.toString(),
            "endTime": start.add(Duration(minutes: duration)).toString(),
            "priority": tasks[i]["priority"],
            "notes": tasks[i]["notes"],
            "color": _colorCollection[random.nextInt(9)].value,
            "complete": false,
          });
          timeLeft = duration;
          // tasks[i]["time"] -= duration;
          break;
        }
      }
    }

    Utility.writeIntoTimeTable(ttData);
    print(tasks);
    // print(time);
    // print(tasks);
    Utility.writeIntoTask({
      "limit": limit,
      "Tasks": tasks,
    });
    Utility.writeIntoTime(time);
  }

  static void deleteTimeTable(Map<String, dynamic> task) async {
    // Utility.localFileTimeTable.then((file) {
    //   file.exists().then((status) {
    //     if (status) {
    //       file.readAsString().then((content) {
    //         List<dynamic> tasks = jsonDecode(content);
    //         tasks.removeWhere((element) =>
    //             element["startTime"] == widget.tasks.startTime.toString());
    //         if (tasks.isEmpty) tasks = [];
    //         file.writeAsString(jsonEncode(tasks), mode: FileMode.writeOnly);
    //         Navigator.pop(context, true);
    //       });
    //     }
    //   });
    dynamic ttData = await Utility.readFromTimeTable();
    List<dynamic> tt = [];

    if (ttData != null) tt = await ttData;
    print(task["startTime"]);
    tt.removeWhere((ele) => ele["subject"] == task["subject"]);

    // if (tt.isNotEmpty) {
    //   tt = [];
    // }

    if (ttData != null) Utility.writeIntoTimeTable(tt);
    // Utility.
    // Utility.localFileTask.then((file) {
    //   file.exists().then((status) {
    //     if (status) {
    //       file.readAsString().then((content) {
    //         Map<String, dynamic> object = jsonDecode(content);
    //         List<dynamic> tasks = object["Tasks"];
    //         for (int i = 0; i < tasks.length; i++) {
    //           if (tasks[i]["name"] == widget.tasks.subject) {
    //             tasks[i]["time"] += widget.tasks.startTime
    //                 .difference(widget.tasks.endTime)
    //                 .inMinutes;
    //             if (tasks[i]["time"] <= 0) {
    //               tasks.remove(tasks[i]);
    //             }
    //             print(object["limit"]);
    //             int k = diff(widget.tasks.startTime.isBefore(DateTime.now())
    //                     ? DateTime.now().add(Duration(minutes: 15))
    //                     : widget.tasks.startTime)
    //                 .difference(widget.tasks.endTime)
    //                 .inMinutes;
    //             print(k);
    //             object["limit"] += k;
    //             print(object["limit"]);
    //             break;
    //           }
    //         }
    //         file.writeAsString(jsonEncode(object), mode: FileMode.writeOnly);
    //       });
    //       }
    //     });
    //   });
    // });
  }

  static Future<dynamic> editTask(dynamic task) async {
    dynamic tasksData = await Utility.readFromTask();
    List<dynamic> tasks = [];
    int limit = 0;
    if (tasksData != null) {
      tasks = tasksData["Tasks"];
      limit = tasksData["limit"];
      print(tasksData);
    }
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i]["name"] == task["name"]) {
        limit += (task["time"] - tasks[i]["time"]) as int;
        tasks[i]["name"] = task["name"];
        tasks[i]["priority"] = task["priority"];
        tasks[i]["time"] = task["time"];
        tasks[i]["notes"] = task["notes"];
        print(tasksData);
        break;
      }
    }
    if (tasksData != null) {
      Utility.writeIntoTask({"limit": limit, "Tasks": tasks});
      return {"limit": limit, "Tasks": tasks};
    }
  }
}

DateTime diff(DateTime start) {
  if (start.compareTo(DateTime.now()) < 0) {
    return DateTime.now();
  }
  return start;
}
