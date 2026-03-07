import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/services/local_storage.dart';

class OnboardingController extends GetxController {

  final RxBool isLoading = false.obs;

  /// Open Facebook link in browser
  Future<void> openFacebookLink() async {
    final Uri url = Uri.parse("https://www.facebook.com/YOUR_PAGE_LINK");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Unable to open link");
    }
  }

  /// Continue button logic (acts like login / first entry)
  Future<void> continueToApp() async {
    isLoading.value = true;

    // Save first launch flag
    await LocalStorage.set('isFirstLaunch', false);

    isLoading.value = false;

    // Navigate to Dial Page
    Get.offAllNamed(Routes.DIAL_PAGE);
  }
}
