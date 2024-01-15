class CalendarEventModel {
  final String title, description, dateTime, color;

  CalendarEventModel(
      {required this.color,
      required this.dateTime,
      required this.description,
      required this.title});

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
        color: json['color'],
        dateTime: json['dateTime'],
        description: json['description'],
        title: json['title']);
  }
}
