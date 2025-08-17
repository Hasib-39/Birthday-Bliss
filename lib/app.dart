import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'routes.dart';

class RomanticBirthdayApp extends StatelessWidget {
  const RomanticBirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Romantic Birthday',
      theme: buildTheme(),
      initialRoute: Routes.home,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
