import 'package:fix_my_life/time_update.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'timetable.dart';
import 'taskframe.dart';
import 'utility.dart';
import 'time_input_frame.dart';

const timeList = "/timeList";
void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyNavigationBar(),
      // initialRoute: '/',
      routes: {
        timeList: (context) {
          return TimeList();
        },
        todoList: (context) {
          return TodoList();
        },
      },
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 2;
  static List<Widget> _widgetOptions = <Widget>[
    TaskFrame(),
    DateTimePicker(),
    Timetable(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      k = 1;
      // Utility.localFileTime.then((file) {
      //   file.delete();
      // });
      // Utility.localFileTimeTable.then((file) {
      //   file.delete();
      // });
      // Utility.localFileTask.then((file) {
      //   file.delete();
      // });
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.task_sharp),
              label: ('Task Input'),
              backgroundColor: Colors.grey[850],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_alarms),
              label: ('Time Input'),
              backgroundColor: Colors.grey[850],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day_rounded),
              label: ('Timetable'),
              backgroundColor: Colors.grey[850],
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange[400],
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
