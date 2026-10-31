import 'package:flutter_test/flutter_test.dart';
import 'package:placement/models/acknowledgementModel.dart';

void main() {
  group('AcknowledgementModel.fromJson', () {
    test('reads the documented shape', () {
      var m = AcknowledgementModel.fromJson({
        'season': 'int',
        'acknowledgedSeason': 'nel',
        'needsAcknowledgement': true,
      });
      expect(m.season, 'int');
      expect(m.acknowledgedSeason, 'nel');
      expect(m.needsAcknowledgement, isTrue);
      expect(m.seasonName, 'Internship');
    });

    test('treats missing fields as nothing to acknowledge', () {
      var m = AcknowledgementModel.fromJson({});
      expect(m.season, 'nel');
      expect(m.needsAcknowledgement, isFalse);
    });

    test('falls back to the code for an unknown season', () {
      expect(AcknowledgementModel.fromJson({'season': 'xyz'}).seasonName, 'xyz');
    });
  });

  group('isAcknowledgementRequired', () {
    test('matches the gate 403', () {
      expect(isAcknowledgementRequired(
              403, '{"error":"acknowledgement_required"}'),
          isTrue);
    });

    test('ignores the not-an-active-student 403', () {
      expect(isAcknowledgementRequired(
              403, '{"detail":"You do not have permission"}'),
          isFalse);
    });

    test('ignores other statuses and non-JSON bodies', () {
      expect(isAcknowledgementRequired(
              400, '{"error":"acknowledgement_required"}'),
          isFalse);
      expect(isAcknowledgementRequired(403, '<html>Forbidden</html>'), isFalse);
      expect(isAcknowledgementRequired(403, '["acknowledgement_required"]'),
          isFalse);
    });
  });

  test('errorFromBody reads the error field', () {
    expect(errorFromBody('{"error":"No season is open for you"}'),
        'No season is open for you');
    expect(errorFromBody(''), isNull);
  });
}
