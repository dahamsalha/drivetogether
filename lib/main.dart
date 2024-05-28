import 'package:drivetogether/views/Administrateur_page.dart';
import 'package:drivetogether/views/Avis_conducteur_page.dart';
import 'package:drivetogether/views/Avis_passager_page.dart';
import 'package:drivetogether/views/Changerpassword_page.dart';
import 'package:drivetogether/views/Parametre&aide_page.dart';
import 'package:drivetogether/views/espaceconducteur_page.dart';
import 'package:drivetogether/views/espacepassager_page.dart';
import 'package:drivetogether/views/home_page.dart';
import 'package:drivetogether/views/login_page.dart';
import 'package:drivetogether/views/motdepasseoublie_page.dart';
import 'package:drivetogether/views/profilUtilisateur_page.dart';
import 'package:drivetogether/views/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'package:drivetogether/views/trajet-page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveTogether',
      supportedLocales: [
        Locale('fr', 'FR'), // Français
        Locale('en', 'US'), // Anglais
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale, // Utilise la langue sélectionnée
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
        '/Administrateur': (context) => AdminPage(),
        '/settings': (context) => SettingsPage(), // Add route for SettingsPage
        '/change_password': (context) => ChangerPasswordPage(),
        '/Avis-conducteur': (context) => AvisConducteurPage(),
        '/Avis-passager': (context) => AvisPassagerPage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
         // Ajout de cette ligne // Ajoutez cette ligne pour la route de modification de mot de passe
        //'/statistique': (context) => StatisticsPage(), // Ajout de la route pour la page Statistique
      },
    );
  }
}