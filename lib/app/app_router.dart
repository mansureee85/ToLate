import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/admin/presentation/admin_audit_log_screen.dart';
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/admin/presentation/admin_listing_queue_screen.dart';
import '../features/admin/presentation/admin_location_manager_screen.dart';
import '../features/admin/presentation/admin_login_screen.dart';
import '../features/admin/presentation/admin_reports_queue_screen.dart';
import '../features/admin/presentation/admin_shell_screen.dart';
import '../features/admin/presentation/admin_verification_center_screen.dart';
import '../features/auth/presentation/login_phone_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/otp_verification_screen.dart';
import '../features/auth/presentation/role_selection_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/feed/presentation/home_feed_screen.dart';
import '../features/interactions/presentation/inquiries_dashboard_screen.dart';
import '../features/interactions/presentation/notifications_screen.dart';
import '../features/interactions/presentation/viewing_requests_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/settings_privacy_screen.dart';
import '../features/properties/presentation/property_details_screen.dart';
import '../features/properties/presentation/property_wizard_start_screen.dart';
import '../features/search/presentation/saved_searches_screen.dart';
import '../features/search/presentation/search_results_screen.dart';
import '../features/search/presentation/search_wizard_screen.dart';
import 'customer_shell.dart';
import 'route_names.dart';

/// App Router configuration with ShellRoute and URL matching.
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'customerShell');
  static final GlobalKey<NavigatorState> _adminShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'adminShell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    routes: [
      // 1. Launch & Auth Routes
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.loginPhone,
        builder: (context, state) => const LoginPhoneScreen(),
      ),
      GoRoute(
        path: RouteNames.otpVerify,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: RouteNames.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      // 2. Main Customer Shell Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => CustomerShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const HomeFeedScreen(),
          ),
          GoRoute(
            path: RouteNames.searchWizard,
            builder: (context, state) => const SearchWizardScreen(),
          ),
          GoRoute(
            path: RouteNames.postProperty,
            builder: (context, state) => const PropertyWizardStartScreen(),
          ),
          GoRoute(
            path: RouteNames.saved,
            builder: (context, state) => const SavedSearchesScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // 3. Sub-pages
      GoRoute(
        path: RouteNames.searchResults,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => SearchResultsScreen(
          queryParameters: state.uri.queryParameters,
        ),
      ),
      GoRoute(
        path: '/property/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => PropertyDetailsScreen(
          listingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsPrivacyScreen(),
      ),
      GoRoute(
        path: RouteNames.inquiries,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InquiriesDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.viewings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ViewingRequestsScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // 4. Admin Web Panel
      GoRoute(
        path: RouteNames.adminLogin,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _adminShellNavigatorKey,
        builder: (context, state, child) => AdminShellScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.adminDashboard,
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: RouteNames.adminListings,
            builder: (context, state) => const AdminListingQueueScreen(),
          ),
          GoRoute(
            path: RouteNames.adminVerification,
            builder: (context, state) => const AdminVerificationCenterScreen(),
          ),
          GoRoute(
            path: RouteNames.adminReports,
            builder: (context, state) => const AdminReportsQueueScreen(),
          ),
          GoRoute(
            path: RouteNames.adminLocations,
            builder: (context, state) => const AdminLocationManagerScreen(),
          ),
          GoRoute(
            path: RouteNames.adminAudit,
            builder: (context, state) => const AdminAuditLogScreen(),
          ),
        ],
      ),
    ],
  );
}
