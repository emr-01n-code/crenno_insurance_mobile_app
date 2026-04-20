class AppRoutes {
  AppRoutes._();

  static const String policiesPath = '/';
  static const String policiesName = 'policies';

  static const String policyDetailPath = '/policy/:id';
  static const String policyDetailName = 'policy-detail';

  static const String claimSubmissionPath = '/policy/:id/claim';
  static const String claimSubmissionName = 'claim-submission';

  static String policyDetail(String id) => '/policy/$id';
  static String claimSubmission(String id) => '/policy/$id/claim';
}
