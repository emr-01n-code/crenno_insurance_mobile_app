class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://mock.insurance.local/api/v1';

  static const String policies = '/policies';
  static String policyById(String id) => '/policies/$id';

  static const String claims = '/claims';
}
