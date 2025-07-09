import 'package:day_04_profile_ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileUIApp extends StatelessWidget {
  const ProfileUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const ProfileScreen(),
    );
  }
}
