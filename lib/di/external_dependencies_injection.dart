// import 'package:firebase_auth/firebase_auth.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

import './locator.dart';

void initExternalDependencies() {
  // Firebase
  // locator.registerLazySingleton(() => FirebaseAuth.instance);

  // data connection checker
  locator.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());
}
