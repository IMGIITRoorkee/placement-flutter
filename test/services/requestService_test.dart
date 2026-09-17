import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:placement/services/generic/requestService.dart';

/// Stands in for the real auth headers so these tests need no signed-in
/// session (and therefore no Hive box).
Future<Map<String, String>> _stubHeaders(String endpoint) async =>
    {'Authorization': 'Bearer test-token'};

RequestService _serviceReturning(http.Response response) => RequestService(
      client: MockClient((_) async => response),
      headerProvider: _stubHeaders,
    );

void main() {
  const _endpoint = 'https://example.com/applications/';
  const _body = {'profile': '1', 'resume': '2'};

  group('makePostRequest', () {
    test('returns the 201 the applications endpoint sends on success',
        () async {
      final _service = _serviceReturning(http.Response('{"id": 7}', 201));

      final _res = await _service.makePostRequest(_endpoint, _body);

      expect(_res, isNotNull);
      expect(_res!.statusCode, 201);
    });

    test('returns the 418 body so the caller can surface the error', () async {
      final _service = _serviceReturning(
          http.Response('{"error": "You have no credits left"}', 418));

      final _res = await _service.makePostRequest(_endpoint, _body);

      expect(_res, isNotNull);
      expect(_res!.statusCode, 418);
      expect(_res.body, contains('You have no credits left'));
    });

    test('returns null when the request cannot be made', () async {
      final _service = RequestService(
        client: MockClient((_) async => throw http.ClientException('offline')),
        headerProvider: _stubHeaders,
      );

      expect(await _service.makePostRequest(_endpoint, _body), isNull);
    });

    test('sends the auth headers from the header provider', () async {
      String? _sentAuthorization;
      final _service = RequestService(
        client: MockClient((request) async {
          _sentAuthorization = request.headers['authorization'];
          return http.Response('', 201);
        }),
        headerProvider: _stubHeaders,
      );

      await _service.makePostRequest(_endpoint, _body);

      expect(_sentAuthorization, 'Bearer test-token');
    });
  });
}
