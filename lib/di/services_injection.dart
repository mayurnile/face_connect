import './locator.dart';
import '../services/navigation_service.dart';

void initServices() {
  // Navigation Service
  locator.registerLazySingleton(() => NavigationService());
}
