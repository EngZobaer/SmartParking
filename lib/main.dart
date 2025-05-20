import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart'; // Import the DashboardPage
import 'drawer.dart'; // Import the CustomDrawer
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _percent = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Update percent every 30ms, target 100% in 3 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        if (_percent < 100) {
          _percent++;
        } else {
          _timer?.cancel();
          _checkUserAuthentication();  // Check authentication once the progress bar is 100%
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Check user authentication
  Future<void> _checkUserAuthentication() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // If the user is logged in, navigate to the Dashboard, otherwise navigate to the Login page
    if (_auth.currentUser != null) {
      // If user is logged in, navigate to Dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      // If no user is logged in, navigate to Login page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = _percent / 100;

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SMART Parking Management System',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.white.withOpacity(0.3),
                color: Colors.white,
                minHeight: 8,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading $_percent%',
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
