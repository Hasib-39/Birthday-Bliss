import 'package:flutter/material.dart';
import 'features/birthday/screens/home_screen.dart';
import 'features/birthday/screens/wish_screen.dart';

class Routes {
  static const home = '/';
  static const wish = '/wish';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case wish:
        return MaterialPageRoute(builder: (_) => const WishScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
