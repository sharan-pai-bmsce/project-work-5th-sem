import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'task_detail.dart';
import 'task_body.dart';
import 'utility.dart';

const TaskDetailRoute = '/task_detail';

class Timetable extends StatelessWidget {
  const Timetable({Key? key}) : super(key: key);
  RouteFactory _route() {
    return (settings) {
      Widget screen;
      Task arguments = settings.arguments as Task;
      // print(arguments);
      // print(arguments.toString());
      switch (settings.name) {
        case '/':
          screen = AppointmentWithoutWeekends();
          break;
        case TaskDetailRoute:
          screen = TaskDetail(tasks: arguments);
          break;
        default:
          return null;
      }
      return MaterialPageRoute(
          builder: (BuildContext context) => screen, maintainState: false);
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: _route(), home: AppointmentWithoutWeekends());
  }
}

class AppointmentWithoutWeekends extends StatefulWidget {
  @override
  CalendarAppointment createState() => CalendarAppointment();
}

class CalendarAppointment extends State<AppointmentWithoutWeekends> {
  final CalendarDataSource _dataSource = _DataSource(<Task>[]);
  final List<String> _subjectCollection = <String>[];
  final List<DateTime> _startTimeCollection = <DateTime>[];
  final List<DateTime> _endTimeCollection = <DateTime>[];
  final List<Color> _colorCollection = <Color>[];
  List<TimeRegion> _specialTimeRegion = <TimeRegion>[];
  ViewChangedDetails? x = null;
  @override
  void initState() {
    _getColorCollection();
    super.initState();
    Utility.localFile3.then((file) {
      file.exists().then((stat) {
        if (stat) {
          file.readAsString().then((timeInput) {
            List<dynamic> content = jsonDecode(timeInput);
            DateTime curr = DateTime.now();
            for (int i = 0; i < content.length; i++) {
              DateTime time = DateTime.parse(
                  content[i]["date"] + " " + content[i]["endTime"] + ":00");
              if (time.isBefore(curr)) {
                content.remove(content[i]);
              }
            }
            file.writeAsString(jsonEncode(content));
            setState(() {});
          });
        }
      });
    });

    Utility.localFile1.then((file1) {
      Utility.localFile2.then((file2) {
        file1.readAsString().then((taskInput) {
          Map<String, dynamic> fil1Data = jsonDecode(taskInput);
          List<dynamic> tasks = fil1Data["Tasks"];
          print(tasks);
          file2.readAsString().then((ttInput) {
            List<dynamic> ttData = jsonDecode(ttInput);
            for (int i = 0; i < ttData.length; i++) {
              DateTime startTime = DateTime.parse(ttData[i]["startTime"]);
              DateTime endTime = DateTime.parse(ttData[i]["endTime"]);
              if (endTime.isBefore(DateTime.now())) {
                for (int j = 0; j < tasks.length; j++) {
                  if (tasks[j]["name"] == ttData[i]["name"]) {
                    tasks[j]["time"] += startTime.difference(endTime).inMinutes;
                    if (tasks[j]["time"] <= 0) {
                      tasks.remove(tasks[j]);
                    }
                    break;
                  }
                }
                ttData.remove(ttData[i]);
              }
            }
            setState(() {});
            file1.writeAsString(jsonEncode(fil1Data));
            file2.writeAsString(jsonEncode(ttData));
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: SafeArea(
            child: SfCalendar(
              backgroundColor: Colors.grey[900],
              cellBorderColor: Colors.white,

              // Date and day styling
              viewHeaderStyle: const ViewHeaderStyle(
                  dateTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  dayTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),

              viewHeaderHeight: 55,
              headerHeight: 55,
              appointmentTextStyle:
                  TextStyle(color: Colors.white, fontSize: 16),
              onTap: (CalendarTapDetails ct) {
                bool state = ct.appointments != null
                    ? ct.appointments!.length > 0
                        ? true
                        : false
                    : false;
                if (state) {
                  Task app = ct.appointments![0];
                  Navigator.pushNamed(
                    context,
                    TaskDetailRoute,
                    // (Route<dynamic> route) => false,
                    arguments: app,
                  ).then((value) {
                    if (value == true && x != null) {
                      viewChanged(x!);
                    }
                  });
                  setState(() {});
                }
              },

              showNavigationArrow: true,
              headerStyle: CalendarHeaderStyle(
                  backgroundColor: Colors.grey[850],
                  textStyle: TextStyle(color: Colors.grey[400], fontSize: 30)),
              timeSlotViewSettings: TimeSlotViewSettings(
                  timeIntervalHeight: 40,
                  timeInterval: Duration(minutes: 15),
                  timeFormat: 'hh:mm a',
                  timeRulerSize: 70,
                  timeTextStyle: TextStyle(color: Colors.white)),
              resourceViewSettings: ResourceViewSettings(
                  displayNameTextStyle: TextStyle(color: Colors.black)),
              todayHighlightColor: Colors.orange[300],
              dataSource: _dataSource,
              monthViewSettings: MonthViewSettings(
                  monthCellStyle: MonthCellStyle(
                      textStyle: TextStyle(color: Colors.white),
                      todayBackgroundColor: Colors.orange[300],
                      leadingDatesBackgroundColor: Colors.grey[700])),
              view: CalendarView.day,

              allowedViews: [CalendarView.day, CalendarView.month],
              onViewChanged: viewChanged,
              specialRegions: _specialTimeRegion,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            backgroundColor: Colors.grey[800],
            onPressed: () {}),
      ),
    );
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) async {
    List<DateTime> visibleDates = viewChangedDetails.visibleDates;
    List<TimeRegion> _timeRegion = <TimeRegion>[];
    List<Task> appointments = <Task>[];
    bool stat = false;
    x = viewChangedDetails;
    // This will refresh the window each time the window is loaded. For example when you switch from from 1 date to another previous appointment details will be present and new details will be loaded. This will scrub the previous data and
    _dataSource.appointments!.clear();
    // DateTime x = DateTime.now();
    // DateTime start = DateTime(x.year, x.month, x.day, 12, 30);
    Utility.localFile2.then((file) {
      return file.exists().then((stat) {
        if (stat) {
          appointments.clear();
          _dataSource.appointments!.clear();
          file.readAsString().then((contents) {
            if (contents != "") {
              _dataSource.appointments!.clear();
              List<dynamic> contentJson = jsonDecode(contents as String);
              for (var element in contentJson) {
                _dataSource.appointments!.add(Task(
                  priority: element["priority"],
                  subject: element["name"],
                  startTime: DateTime.parse(element["startTime"]),
                  endTime: DateTime.parse(element["endTime"]),
                  isComplete: element["complete"],
                  color: Color(element["color"]),
                  notes: element["notes"],
                ));
              }
              print(contents);
              // for (var element in contentJson["Completed"]) {
              //   // print(element);
              //   _dataSource.appointments!.add(Task(
              //     priority: element["priority"],
              //     subject: element["name"],
              //     startTime: DateTime.parse(element["startTime"]),
              //     endTime: DateTime.parse(element["endTime"]),
              //     isComplete: element["complete"],
              //     color: Color(element["color"]),
              //     notes: element["notes"],
              //   ));
              // }
              _dataSource.notifyListeners(
                  CalendarDataSourceAction.reset, _dataSource.appointments!);
            }
          });
        }
      });
    });
    // appointments.clear();
    // file.exists().then((value) {
    //   print(value);
    //   appointments.clear();
    //   _dataSource.appointments!.clear();
    //   if (value) {
    //     file.readAsString().then((content) {
    //       appointments.clear();
    //       for (var element in val) {
    //         element.putIfAbsent("start", () => start);
    //         element.putIfAbsent(
    //             "end", () => start.add(Duration(minutes: element["time"])));
    //         start = start.add(Duration(minutes: element["time"]));
    //       }
    //       for (var element in val) {
    //         DateTime startTime = DateTime(
    //             element["start"].year,
    //             element["start"].month,
    //             element["start"].day,
    //             element["start"].hour,
    //             element["start"].minute);
    //         DateTime endTime = DateTime(
    //             element["end"].year,
    //             element["end"].month,
    //             element["end"].day,
    //             element["end"].hour,
    //             element["end"].minute);
    //         var random = Random();
    //       }
    //       // print(_dataSource.appointments.toString());
    //       for (int i = 0; i < appointments.length; i++) {
    //         _dataSource.appointments!.add(appointments[i]);
    //       }

    // });
    // }
    // });

    _dataSource.notifyListeners(
        CalendarDataSourceAction.reset, _dataSource.appointments!);
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
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Task> source) {
    appointments = source;
  }
}
