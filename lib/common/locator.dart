import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../home_page.dart';
import '../login_page.dart';

GetIt sl = GetIt.instance;

setupLocator() {
  sl.registerLazySingleton(() => NavigationManager());
}

class NavItem {
  final IconData icon;
  final String title;
  final Widget widget;

  NavItem({
    @required this.icon,
    @required this.title,
    @required this.widget,
  });
}

class NavigationManager {
  final navigatorKey = GlobalKey<NavigatorState>();

  int get currentIndex => _currentIndex;

  int _currentIndex = 0;

  final currentItem = BehaviorSubject<Widget>();

  final List<NavItem> items = [
    NavItem(
      icon: Icons.dashboard,
      title: 'Dashboard',
      widget: DashboardPage(),
    ),
    NavItem(
      icon: Icons.person,
      title: 'Profile',
      widget: ProfilePage(),
    ),
  ];

  NavigationManager() {
    currentItem.add(items[_currentIndex].widget);
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case HomeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case DetailRoute:
        return MaterialPageRoute(
            builder: (_) => DetailPage(title: settings.arguments as String));
      default:
        return MaterialPageRoute(builder: null);
    }
  }

  push(String routeName, {dynamic args}) =>
      navigatorKey.currentState.pushNamed(routeName, arguments: args);

  root(String routeName, {dynamic arguments}) => navigatorKey.currentState
      .pushReplacementNamed(routeName, arguments: arguments);

  navigateToIndex(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    currentItem.add(items[index].widget);
  }
}

// class Api {
//   final dio = Dio();
//   Future<List<T>> get<T>(String endpoint) async {
//     final response = await dio.get(endpoint);
//     return (jsonDecode(response.data) as List<Map<String,dynamic>>).map((j) => T.fromJson(j)).toList();
//   }
// }

abstract class Codable {
  fromJson(Map<String, dynamic> json);
}

const LoginRoute = 'login';
const HomeRoute = 'home';
const DashboardRoute = 'dashboard';
const ProfileRoute = 'profile';
const DetailRoute = 'detail';

const iMowzMasthead = 'assets/mowzMasthead.png';
const iMulchMasthead = 'assets/mulchMasthead.png';
const iLeavzMasthead = 'assets/leavzMasthead.png';
const iAerationMasthead = 'assets/aerationMasthead.png';
const iPlowzMasthead = 'assets/plowzMasthead.png';
const iLogo = 'assets/logo.png';
