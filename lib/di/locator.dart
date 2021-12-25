import 'package:get_it/get_it.dart';

import './external_dependencies_injection.dart';
import './services_injection.dart';
import './platform_services_injection.dart';
import './controller_injection.dart';

final locator = GetIt.instance;

Future<void> init([String? baseUrl, String? apiKey]) async {
  // External Depdencies
  initExternalDependencies();

  // Services
  initServices();

  // Platform Services
  initPlatformServices();

  // Controllers
  initControllers();
}
