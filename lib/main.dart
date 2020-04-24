import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nav = sl<NavigationManager>();
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      navigatorKey: nav.navigatorKey,
      onGenerateRoute: nav.onGenerateRoute,
      initialRoute: LoginRoute,
    );
  }
}
