import 'dart:convert';

import 'package:fix_my_life/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeList extends StatefulWidget {
  const TimeList({Key? key}) : super(key: key);

  @override
  _TimeListState createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  int limit = 0;
  List<dynamic> time = [];

  @override
  void initState() {
    super.initState();
    Utility.readFromTime().then((contents) {
      print(contents);
      if (contents != null) {
        time = contents;
      }
      setState(() {});
    });
    // getAllTasks();
  }

  _showDeleteDialog(BuildContext context, startTime) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: <Widget>[
              FlatButton(
                  color: Colors.green,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[350]),
                  )),
              FlatButton(
                  color: Colors.red,
                  onPressed: () async {
                    dynamic dtime = time.firstWhere(
                        (element) => element["startTime"] == startTime);
                    print(await dtime);
                    if (await dtime != null) {
                      Utility.deleteTime(null, dtime).then((content) {
                        time = content;
                        setState(() {});
                      });
                    }
                    Navigator.pop(context);
                    _showSuccessSnackBar(context, Text('Deleted Successfully'));
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.grey[350]),
                  )),
            ],
            title: Text('Are you sure you want to delete this?',
                style: TextStyle(color: Colors.grey[400])),
          );
        });
  }

  _showSuccessSnackBar(context, message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    // _globalKey.currentState!.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // key: _globalKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, time);
            }),
        title: Text(
          "Time List",
          style: TextStyle(color: Colors.grey[400]),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView.builder(
          itemCount: time.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                color: Colors.grey[850],
                elevation: 8.0,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        time[index]["date"] +
                            ": " +
                            time[index]["startTime"] +
                            "-" +
                            time[index]["endTime"],
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      IconButton(
                          onPressed: () {
                            _showDeleteDialog(
                                context, time[index]["startTime"]);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
