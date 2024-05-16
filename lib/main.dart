import 'package:drivetogether/views/espaceconducteur_page.dart';
import 'package:drivetogether/views/espacepassager_page.dart';
import 'package:drivetogether/views/home_page.dart';
import 'package:drivetogether/views/login_page.dart';
import 'package:drivetogether/views/profilUtilisateur_page.dart';
import 'package:drivetogether/views/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'package:drivetogether/views/trajet-page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveTogether',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home', // Set initial route to the home page
      routes: {
        '/home': (context) => HomePage(), // Home page route
        '/login': (context) => LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/passager': (context) => PassengerDashboard(),
        '/conducteur': (context) => ConducteurDashboard(),
        '/profile': (context) => ProfilePage(), // Route pour la page de profil
      },
    );
  }
}