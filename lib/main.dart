import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/service_locator.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/modern_home_page.dart';
import 'features/home/presentation/screens/home_page.dart';
import 'features/tournament/presentation/providers/tournament_provider.dart';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/service_locator.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/modern_home_page.dart';
import 'features/home/presentation/screens/home_page.dart';
import 'features/tournament/presentation/providers/tournament_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Turkish locale for date formatting
  await initializeDateFormatting('tr_TR', null);
  
  // Initialize dependency injection before running the app
  setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TournamentProvider()),
      ],
      child: MaterialApp(
        title: 'World Cup Prediction App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        // Start app at LoginScreen for beta testing (Guest Mode will navigate to HomePage)
        home: const LoginScreen(),
        // home: const ModernHomePage(),
        // home: const HomeScreen(),
      ),
    );
  }
}

