import 'package:get/get.dart';

import '../modules/dial_number_history/bindings/dial_number_history_binding.dart';
import '../modules/dial_number_history/views/dial_number_history_view.dart';
import '../modules/dial_page/bindings/dial_page_binding.dart';
import '../modules/dial_page/views/dial_page_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DIAL_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.DIAL_PAGE,
      page: () => const DialPageView(),
      binding: DialPageBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.DIAL_NUMBER_HISTORY,
      page: () => const DialNumberHistoryView(),
      binding: DialNumberHistoryBinding(),
    ),
  ];
}
