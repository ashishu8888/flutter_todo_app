class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  int? color;

  Task(
      {this.id,
      this.title,
      this.note,
      this.isCompleted,
      this.date,
      this.color});

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        title: json['title'].toString(),
        note: json['note'],
        isCompleted: json['isCompleted'],
        date: json['date'],
        color: json['color']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'note': note,
      'isCompleted': isCompleted,
      'color': color,
    };
  }
}
