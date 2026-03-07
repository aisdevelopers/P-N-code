import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/modules/dial_page/controllers/theme_controller.dart';
import 'app/modules/settings/models/animation_duration_model.dart';
import 'app/modules/settings/models/animation_type_model.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/services/local_storage.dart';
import 'app/utils/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(AnimationDurationAdapter());
  Hive.registerAdapter(AnimationsTypeAdapter());

  await LocalStorage.init();

  Get.put(ThemeController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isFirstLaunch = LocalStorage.get<bool>('isFirstLaunch') ?? true;

    return GetMaterialApp(
      getPages: AppPages.routes,
      initialRoute: isFirstLaunch ? Routes.ONBOARDING : AppPages.INITIAL,
      themeMode: ThemeController.instance.themeMode,
      theme: PNAppTheme.lightThemeData,
      darkTheme: PNAppTheme.darkThemeData,
    );
  }
}
