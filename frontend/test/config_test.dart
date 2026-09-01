import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/urls.dart';

void main() {
  test('default emulator API URL contains no embedded credential', () {
    expect(baseUrl, 'http://10.0.2.2:8000');
    expect(baseUrl, isNot(contains('Api-Key')));
    expect(baseUrl, isNot(contains('@')));
  });
}
