import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
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
    final result =
        await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData();
      // Gérer la connexion réussie avec Facebook
      print(userData);
    } else {
      // Gérer l'échec de connexion avec Facebook
      print(result.status);
      print(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "L'e-mail ne peut pas être vide." : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Mot de passe",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.length < 8
                          ? "Le mot de passe doit comporter au moins 8 caractères."
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    AuthService()
                        .loginWithEmail(
                            emailController.text, passwordController.text)
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
                  const Text("Vous n'avez pas de compte?"),
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