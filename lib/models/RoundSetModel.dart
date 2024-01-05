class RoundSetModel {
  final int id, profile, index;
  final String name, date, time;

  RoundSetModel(
      {required this.date,
      required this.id,
      required this.index,
      required this.name,
      required this.profile,
      required this.time});

  factory RoundSetModel.fromJson(Map<String, dynamic> json) {
    return RoundSetModel(
      date: json['date'],
      id: json['id'],
      index: json['index'],
      name: json['name'],
      profile: json['profile'],
      time: json['time'],
    );
  }
}
