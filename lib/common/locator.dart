import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../home_page.dart';
import '../login_page.dart';
import 'constants.dart';

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
