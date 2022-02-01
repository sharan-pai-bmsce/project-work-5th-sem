class Task {
  int? id;
  String name = "";
  String description = "";
  int priority = 0;
  int duration = 0;

  taskMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;
    mapping['priority'] = priority;
    mapping['duration'] = duration;
    return mapping;
  }
}
