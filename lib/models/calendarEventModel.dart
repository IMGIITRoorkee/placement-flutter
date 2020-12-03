class CalendarEventModel {
  final String title,
    description,
    dateTime,
    color;
  
  CalendarEventModel({
    this.color,
    this.dateTime,
    this.description,
    this.title
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      color: json['color'],
      dateTime: json['dateTime'],
      description: json['description'],
      title: json['title']
    );
  }
}