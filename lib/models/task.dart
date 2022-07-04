class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task({
    this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.remind,
    required this.repeat,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'].toString();
    note = json['note'].toString();
    isCompleted = json['isCompleted'];
    date = json['date'].toString();
    startTime = json['startTime'].toString();
    endTime = json['endTime'].toString();
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['repeat'] = this.remind;

    return data;
  }
}
