class Task {
  int id;
  String title;
  DateTime tgl;
  String priority;
  int status;

  Task({this.title, this.tgl, this.priority, this.status});

  Task.withId({this.id, this.title, this.tgl, this.priority, this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['tgl'] = tgl.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map['id'],
        title: map['title'],
        tgl: DateTime.parse(map['tgl']),
        priority: map['priority'],
        status: map['status']);
  }
}
