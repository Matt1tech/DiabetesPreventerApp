import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/urls.dart';

void main() {
  test('default emulator API URL contains no embedded credential', () {
    expect(baseUrl, 'http://10.0.2.2:8000');
    expect(baseUrl, isNot(contains('Api-Key')));
    expect(baseUrl, isNot(contains('@')));
  });

  test('user data accepts an absent profile picture', () {
    final user = User.fromJson({
      'id': 1,
      'name': 'Alex Morgan',
      'email': 'alex@example.test',
      'gender': 'Other',
      'marital_status': 'Single',
      'height': 170,
      'birthdate': '1990-01-01',
      'family_history': false,
      'profile_picture': null,
      'created_at': '2026-09-02T00:00:00Z',
    });

    expect(user.profile_picture, isNull);
    expect(user.height, 170.0);
  });
}
