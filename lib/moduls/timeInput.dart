// ignore_for_file: file_names

class TimeInput {
  int? id;
  String date = "";
  String startTime = "";
  String endTime = "";

  timeMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping["date"] = date;
    mapping["startTime"] = startTime;
    mapping["endTime"] = endTime;
    return mapping;
  }
}
