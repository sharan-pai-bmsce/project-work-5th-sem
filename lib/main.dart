import 'package:flutter/material.dart';
// import 'timetable.dart';
import 'taskframe.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Text('Home Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    TaskFrame(),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    // AppointmentWithoutWeekends(),
  ];

  void _onItemTapped(int index) {
    setState(() {
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
              icon: Icon(Icons.home),
              label: ('Time Input'),
              backgroundColor: Colors.grey[850],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_sharp),
              label: ('Task Input'),
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
