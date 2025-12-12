import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/service_locator.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  // Initialize dependency injection before running the app
  setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Cup Prediction App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

