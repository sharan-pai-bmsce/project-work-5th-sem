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


// _getStartTimeCollection();
//     _getEndTimeCollection();

// void _getStartTimeCollection() {
//     var currentDateTime = DateTime.now();

//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 9, 0, 0));
//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 10, 0, 0));
//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 11, 0, 0));
//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 12, 0, 0));
//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 14, 0, 0));
//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 15, 0, 0));
//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 16, 0, 0));
//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 17, 0, 0));
//     _startTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 18, 0, 0));
//   }

//   void _getEndTimeCollection() {
//     var currentDateTime = DateTime.now();
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 10, 0, 0));
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 11, 0, 0));
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 12, 0, 0));
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 13, 0, 0));
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 15, 0, 0));
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 16, 0, 0));
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 17, 0, 0));
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 18, 0, 0));
//     _endTimeCollection.add(new DateTime(currentDateTime.year,
//         currentDateTime.month, currentDateTime.day, 19, 0, 0));
//   }


//  _getSubjectCollection();
// void _getSubjectCollection() {
//     _subjectCollection.add('General Meeting');
//     _subjectCollection.add('Plan Execution');
//     _subjectCollection.add('Project Plan');
//     _subjectCollection.add('Consulting');
//     _subjectCollection.add('Support');
//     _subjectCollection.add('Development Meeting');
//     _subjectCollection.add('Scrum');
//     _subjectCollection.add('Project Completion');
//     _subjectCollection.add('Release updates');
//     _subjectCollection.add('Performance Check');
//   }
  

