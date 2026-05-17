import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'pages/login_page.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.surface,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Node.js backend integration will be initialized here if needed

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uni Helper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginFormLayout(),
      routes: {
        '/login': (context) => const LoginFormLayout(),
      },
    );
  }
}