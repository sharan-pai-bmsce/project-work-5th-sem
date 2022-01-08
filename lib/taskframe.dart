import 'package:flutter/material.dart';

class TaskFrame extends StatefulWidget {
  const TaskFrame({Key? key}) : super(key: key);

  @override
  _TaskFrameState createState() => _TaskFrameState();
}

class _TaskFrameState extends State<TaskFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: const Text("Task Manager"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list_alt),
              onPressed: () {},
            )
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation(),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.grey[850],
        //   child: Text(
        //     "+",
        //     style: TextStyle(fontSize: 25),
        //   ),
        //   onPressed: () {},
        // ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 40),
            margin: EdgeInsets.fromLTRB(30, 20, 30, 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[700],
            ),
            child: Column(
              children: const <Widget>[
                Divider(height: 40),
                ListTile(
                  leading: Icon(Icons.title_rounded, color: Colors.white),
                  title: TextField(
                      decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(color: Colors.white),
                  )),
                ),
                Divider(height: 40),
                ListTile(
                    leading:
                        Icon(Icons.low_priority_rounded, color: Colors.white),
                    title: TextField(
                        decoration: InputDecoration(
                      hintText: "Task Priority",
                      hintStyle: TextStyle(color: Colors.white),
                    ))),
                Divider(height: 40),
                ListTile(
                    leading: Icon(Icons.timelapse, color: Colors.white),
                    title: TextField(
                        decoration: InputDecoration(
                      hintText: "Approx. time to finish",
                      hintStyle: TextStyle(color: Colors.white),
                    ))),
                Divider(height: 40),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.grey[700]),
            onPressed: () {},
            child: const Text(
              'Generate Timetable',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(height: 10, color: Colors.grey[900]),
          ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.add),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder()),
              padding: MaterialStateProperty.all(EdgeInsets.all(20)),
              backgroundColor: MaterialStateProperty.all(
                  Colors.grey[700]), // <-- Button color
              overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                if (states.contains(MaterialState.pressed))
                  return Colors.grey[870]; // <-- Splash color
              }),
            ),
          )
        ])));
  }
}
