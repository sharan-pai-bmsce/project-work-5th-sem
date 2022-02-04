import 'package:fix_my_life/moduls/timeInput.dart';
import 'package:flutter/foundation.dart';
import 'package:fix_my_life/reposi/repository.dart';

class TimeService {
  Repository? _repository;

  TimeService() {
    _repository = Repository();
  }
  //Create data
  saveTime(TimeInput task) async {
    return await _repository!.insertData('timeInput', task.timeMap());
  }

  readTime() async {
    return await _repository!.readData('timeInput');
  }

  // read data from table by id
  readTimeById(timeID) async {
    return await _repository!.readDataById('timeInput', timeID);
  }

  //
  updateTime(TimeInput time) async {
    return await _repository!.updateData('timeInput', time.timeMap());
  }

  deleteTime(timeId) async {
    return await _repository!.deleteData('timeInput', timeId);
  }
}
