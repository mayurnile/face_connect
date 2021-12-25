import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './core/core.dart';
import './di/locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const ContactSharing());
}

class ContactSharing extends StatelessWidget {
  const ContactSharing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Sharing',
      theme: AppTheme.getAppThemeData(),
      navigatorKey: di.locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }
}
