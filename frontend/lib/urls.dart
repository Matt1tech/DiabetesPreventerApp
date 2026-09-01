/// Public runtime configuration; never place credentials in `--dart-define`.
const String baseUrl = String.fromEnvironment(
  'DIABETES_API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
