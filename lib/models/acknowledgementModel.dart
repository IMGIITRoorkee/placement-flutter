import 'dart:convert';

/// The student's acknowledgement state for the current season, as returned
/// by GET and POST on the acknowledgement endpoint.
class AcknowledgementModel {
  /// Season code: pla, int, ear or nel.
  final String season;

  /// Season the student last accepted the acknowledgement for.
  final String acknowledgedSeason;

  final bool needsAcknowledgement;

  AcknowledgementModel({
    required this.season,
    required this.acknowledgedSeason,
    required this.needsAcknowledgement,
  });

  factory AcknowledgementModel.fromJson(Map<String, dynamic> json) {
    return AcknowledgementModel(
      season: json['season']?.toString() ?? 'nel',
      acknowledgedSeason: json['acknowledgedSeason']?.toString() ?? 'nel',
      needsAcknowledgement: json['needsAcknowledgement'] == true,
    );
  }

  String get seasonName => seasonNames[season] ?? season;

  static const Map<String, String> seasonNames = {
    'pla': 'Placement',
    'int': 'Internship',
    'ear': 'Early Internship',
    'nel': 'Not Eligible',
  };
}

/// Reads the `error` field of a JSON error body, or null when the body is
/// not a JSON object.
String? errorFromBody(String body) {
  try {
    var decoded = json.decode(body);
    if (decoded is Map && decoded['error'] is String) {
      return decoded['error'];
    }
  } catch (_) {}
  return null;
}

/// True for the 403 every PIC endpoint returns while the student has not
/// accepted the acknowledgement for the open season.
bool isAcknowledgementRequired(int statusCode, String body) {
  return statusCode == 403 && errorFromBody(body) == 'acknowledgement_required';
}
