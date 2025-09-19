import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/location_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DefectTrackerApp());
}

class DefectTrackerApp extends StatelessWidget {
  const DefectTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Defect Tracker',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/location': (context) => const LocationScreen(),
      },
      // Handle dashboard with arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final empId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => DashboardScreen(empId: empId),
          );
        }
        return null;
      },
    );
  }
}
