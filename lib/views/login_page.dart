import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:drivetogether/views/Administrateur_page.dart';
import 'package:drivetogether/views/espaceconducteur_page.dart';
import 'package:drivetogether/views/espacepassager_page.dart';
import 'package:drivetogether/views/motdepasseoublie_page.dart';
import 'package:drivetogether/views/signup_page.dart';
import 'package:drivetogether/views/background_container.dart';
import '../controllers/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_CLIENT_ID.apps.googleusercontent.com',
  );
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connecté avec Google'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, "/passager");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion annulée'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Erreur de connexion avec Google: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de connexion avec Google'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> facebookLogin() async {
    try {
      final result = await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connecté avec Facebook'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, "/passager");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connexion annulée avec Facebook: ${result.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Erreur de connexion avec Facebook: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de connexion avec Facebook'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                "Login",
                style: GoogleFonts.sora(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "E-mail",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "L'e-mail ne peut pas être vide." : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white70,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) => value!.length < 8
                          ? "Le mot de passe doit comporter au moins 8 caractères."
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        const Text(
                          "Se souvenir de moi",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot_password');
                          },
                          child: const Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    AuthService()
                        .loginWithEmail(emailController.text, passwordController.text)
                        .then((value) {
                      print(value["status"]);
                      if (value["status"] == "Login Successful") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Connexion réussie")),
                        );

                        print("User type: ${value["userType"]}");

                        if (value["userType"] == "Passenger") {
                          Navigator.pushReplacementNamed(context, '/passager');
                        } else if (value["userType"] == "Driver") {
                          Navigator.pushReplacementNamed(context, '/conducteur');
                        } else if (emailController.text.toLowerCase().contains('admin')) {
                          Navigator.pushReplacementNamed(context, '/Administrateur');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value["status"],
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red.shade400,
                          ),
                        );
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Se connecter",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _signInWithGoogle(context),
                    icon: Image.asset(
                      "assets/images/google.png",
                      height: 24,
                      width: 24,
                    ),
                    label: const Text("Google"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: facebookLogin,
                    icon: Image.asset(
                      "assets/images/facebook.png",
                      height: 24,
                      width: 24,
                    ),
                    label: const Text("Facebook"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Vous n'avez pas de compte?",
                    style: TextStyle(color: Color.fromARGB(255, 4, 0, 0)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text("Inscrivez-vous"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
    routes: {
      '/signup': (context) => SignUpPage(),
      '/passager': (context) => PassengerDashboard(),
      '/conducteur': (context) => ConducteurDashboard(),
      '/Administrateur': (context) => AdminPage(),
      '/forgot_password': (context) => ForgotPasswordPage(),
    },
  ));
}
