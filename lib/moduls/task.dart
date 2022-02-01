class Task {
  int? id;
  String name = "";
  String note = "No note was added";
  int time = 0;
  int priority = 0;

  taskMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['notes'] = note;
    mapping['time'] = time;
    mapping['priority'] = priority;
    return mapping;
  }
}
