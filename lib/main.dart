import 'dart:async';
import 'package:college_management/admin/ad_home.dart';
import 'package:college_management/staff/staffHome.dart';
import 'package:college_management/staff/test2.dart';
import 'package:college_management/student/student_homepage.dart';
import 'package:college_management/utility/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'login/register_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
        SplashScreenWrapper(),
      routes:
      {
        '/admin_dashboard': (context) => AdminPanel(),
        '/faculty_dashboard': (context) => FacultyDashboard(),
        '/home': (context) => StudentDashboard(),
        '/login': (context) => LoginScreen2(),
        '/register': (context) => RegisterScreen2(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
           child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

    );
  }
}
class SplashScreenWrapper extends StatefulWidget {

  const SplashScreenWrapper(
      {super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
