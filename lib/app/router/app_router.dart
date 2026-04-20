import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/claims/presentation/pages/claim_submission_page.dart';
import '../../features/policies/presentation/pages/policy_detail_page.dart';
import '../../features/policies/presentation/pages/policy_list_page.dart';
import 'app_routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.policiesPath,
    routes: [
      GoRoute(
        path: AppRoutes.policiesPath,
        name: AppRoutes.policiesName,
        builder: (context, state) => const PolicyListPage(),
        routes: [
          GoRoute(
            path: 'policy/:id',
            name: AppRoutes.policyDetailName,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PolicyDetailPage(policyId: id);
            },
            routes: [
              GoRoute(
                path: 'claim',
                name: AppRoutes.claimSubmissionName,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ClaimSubmissionPage(policyId: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(tr('errors.page_not_found_title'))),
      body: Center(
        child: Text(
          state.error?.message ?? tr('errors.page_not_found_message'),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
});
