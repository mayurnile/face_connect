import 'package:get/get.dart';

import './locator.dart';

import '../controllers/controllers.dart';

void initControllers() {
  // Auth Controller
  final AuthController authController = Get.put(AuthController());
  locator.registerLazySingleton(() => authController);

  // Home Controller
  final HomeController homeController = Get.put(HomeController());
  locator.registerLazySingleton(() => homeController);

  // Request Controller
  final RequestsController requestController = Get.put(RequestsController());
  locator.registerLazySingleton(() => requestController);

  // Friends Contrloller
  final FriendsController friendsController = Get.put(FriendsController());
  locator.registerLazySingleton(() => friendsController);
}
