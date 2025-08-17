import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'screens/birthday_screen.dart';

void main() {
  runApp(const BirthdayApp());
}

class BirthdayApp extends StatelessWidget {
  const BirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: MaterialApp(
        title: "Virtual Birthday Cake",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.pink),
        home: const BirthdayScreen(),
      ),
    );
  }
}
