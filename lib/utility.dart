// ignore_for_file: await_only_futures

import 'dart:convert';
import 'dart:io';
import 'package:fix_my_life/task_body.dart';
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

  static void eliminatepreviousTime() async {
    dynamic content = await Utility.readFromTime();
    List<dynamic> timeList = [];
    if (content != null) timeList = content;
    DateTime curr = DateTime.now();
    for (int i = 0; i < timeList.length; i++) {
      DateTime time = DateTime.parse(
          content[i]["date"] + " " + content[i]["endTime"] + ":00");
      if (time.isBefore(curr)) {
        timeList.remove(timeList[i]);
      }
    }
    if (content != null) Utility.writeIntoTime(timeList);
  }

  static void eliminatepreviousTask() async {
    dynamic tasksData = await Utility.readFromTask();
    dynamic ttData = await Utility.readFromTimeTable();
    List<dynamic> tasks = [], tt = [];
    if (tasksData != null) tasks = tasksData["Tasks"];
    if (ttData != null) tt = ttData;
    for (int i = 0; i < tt.length; i++) {
      DateTime startTime = DateTime.parse(tt[i]["startTime"]);
      DateTime endTime = DateTime.parse(tt[i]["endTime"]);
      if (endTime.isBefore(DateTime.now())) {
        for (int j = 0; j < tasks.length; j++) {
          if (tasks[j]["name"] == tt[i]["name"]) {
            tasks[j]["time"] += startTime.difference(endTime).inMinutes;
            if (tasks[j]["time"] <= 0) {
              tasks.remove(tasks[j]);
            }
            break;
          }
        }
        tt.remove(tt[i]);
      }
    }
    if (tasksData != null)
      Utility.writeIntoTask({"limit": tasksData["limit"], "Tasks": tasks});
    if (ttData != null) Utility.writeIntoTimeTable(tt);
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
                  ? DateTime.now().add(Duration(minutes: 5))
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
    tt.removeWhere((ele) => ele["startTime"] == task["startTime"]);

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
}

DateTime diff(DateTime start) {
  if (start.compareTo(DateTime.now()) < 0) {
    return DateTime.now();
  }
  return start;
}
