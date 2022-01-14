import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Utility {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get localFile1 async {
    final path = await _localPath;
    return File('$path/task-input.json');
  }

  static Future<File> get localFile2 async {
    final path = await _localPath;
    return File('$path/timetable.json');
  }
}


// class Task {
//   String name;
//   int priority;
//   int time;
//   Task({required this.name, required this.priority, required this.time});

//   @override
//   String toString() {
//     return "{name: $name,priority: $priority,time: $time}";
//   }

//   static List<Task> parse(String object) {
//     String res = "";
//     String name = "";
//     int priority = 0;
//     int time = 0;
// //     int i = 0;
//     List<Task> tasks = <Task>[];
//     int size = object.length;
//     for (int i = 0; i < size; i++) {
//       res += object[i];
//       if (object[i] == "}") {
//         // print(res);
//         name = res.substring(res.indexOf("name: ") + 6, res.indexOf(","));
//         res = res.substring(res.indexOf(",") + 1);
//         priority = int.parse(
//             res.substring(res.indexOf("priority: ") + 10, res.indexOf(",")));
//         res = res.substring(res.indexOf(","));
//         time = int.parse(
//             res.substring(res.indexOf("time: ") + 6, res.indexOf("}")));
//         tasks.add(Task(name: name, priority: priority, time: time));
//         res = "";
//       }
//     }
//     return tasks;
//   }
// }
