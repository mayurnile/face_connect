import 'package:get/get.dart';

import './locator.dart';

import '../controllers/controllers.dart';

void initControllers() {
  // Auth Controller
  final AuthController authController = Get.put(AuthController());
  locator.registerLazySingleton(() => authController);

  // Home Contoller
  final HomeController homeController = Get.put(HomeController());
  locator.registerLazySingleton(() => homeController);
}
