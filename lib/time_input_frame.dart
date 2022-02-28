import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'utility.dart';

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  Widget _buildAboutText() {
    return new RichText(
        text: new TextSpan(
      text: message,
      // text: 'Free End time can\'t be greater than Start Time\n\n',
      style: const TextStyle(color: Colors.black87),
    ));
  }

  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Error!'),
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

  Widget needed(BuildContext context, String mes) {
    message = mes;
    return _buildAboutDialog(context);
  }

  @override
  void initState() {
    super.initState();
    // Utility.localFile2.then((file) {
    //   return file.readAsString();
    // }).then((contents) {
    //   fileContents = jsonDecode(contents);
    //   // ttData = fileContents["Tasks"];
    //   setState(() {});
    // });
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
              print(limit);
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
                      Text("Time Remaining: ",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      Text(limit > 0 ? convert(limit) : " 00:00",
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
                      // DateTime date = new DateTime(now.year, now.month, now.day);
                      minTime: DateTime(
                          now.year, now.month, now.day, now.hour, now.minute),
                      // maxTime: DateTime(now.year, now.month, now.day),
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
                        builder: (BuildContext context) => needed(context,
                            'Set the date before setting the start timer.\n\n'),
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
                        builder: (BuildContext context) => needed(context,
                            'Free End time can\'t be greater than Start Time\n\n'),
                      );
                    } else if (d.isBefore(DateTime.now())) {
                      print("Time less than current time.");
                      timestart = "Not set";
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => needed(
                              context, "Entered time before current time.")
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
                        builder: (BuildContext context) => needed(context,
                            'Set the date before setting the end timer.\n\n'),
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
                        builder: (BuildContext context) => needed(context,
                            'Free End time can\'t be greater than Start Time\n\n'),
                      );
                    } else if (d.isBefore(DateTime.now())) {
                      print("Time less than current time.");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => needed(
                              context, "Entered time before current time.")
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
                      Utility.generateTimetable(time, tasks, limit)
                          .then((value) {});
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
                            builder: (BuildContext context) => needed(
                                context, "Cannot add time without start time!")
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
                                context, "Cannot add time without end time!")
                            // _buildAboutDialog(context),
                            );
                        setState(() {});
                        return;
                      }
                      if (_date == "Not set") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                needed(context, "Cannot add time without date!")
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
                                needed(context, "Time range already given!")
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


/*
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
