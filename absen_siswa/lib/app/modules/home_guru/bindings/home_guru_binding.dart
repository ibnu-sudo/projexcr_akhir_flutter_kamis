import 'package:get/get.dart';

import '../controllers/home_guru_controller.dart';

class HomeGuruBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeGuruController>(
      () => HomeGuruController(),
    );
  }
}
