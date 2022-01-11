// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'task_body.dart';

class TaskDetail extends StatelessWidget {
  Map<String, dynamic> tasks = {};
  TaskDetail({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(tasks);
    return Scaffold(
      appBar: AppBar(
        title: Text(tasks["name"]),
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
            children: [],
          )),
    );
  }
}
