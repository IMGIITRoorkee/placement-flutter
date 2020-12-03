
class RoundSetModel {
  final int id, profile, index;
  final String  name, date, time;

  RoundSetModel({
    this.date,
    this.id,
    this.index,
    this.name,
    this.profile,
    this.time
  });

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