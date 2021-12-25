import './locator.dart';
import '../core/platform/network_info.dart';

void initPlatformServices() {
  // Network Info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));
}