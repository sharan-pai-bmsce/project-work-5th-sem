import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Task extends Appointment {
  int priority = 0;
  bool isComplete = false;

  Task(
      {required String subject,
      required DateTime startTime,
      required DateTime endTime,
      this.isComplete = false,
      required this.priority,
      String notes = "",
      Color color = Colors.orangeAccent})
      : super(
            subject: subject,
            startTime: startTime,
            endTime: endTime,
            notes: notes,
            color: color);
}
