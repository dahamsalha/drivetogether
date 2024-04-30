import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Importer la bibliothèque Google Sign-In
import '../controllers/auth_service.dart';
// Import the SignUpPage

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Méthode pour gérer la connexion avec Google
  void _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Connecté avec succès avec Google
        // Vous pouvez maintenant utiliser googleUser pour accéder aux informations de l'utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connecté avec Google'),
            backgroundColor: Colors.green,
          ),
        );
        // Naviguer vers la page Passager après la connexion réussie
        Navigator.pushReplacementNamed(context, "/passager");
      } else {
        // L'utilisateur a annulé le processus de connexion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connexion annulée'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Erreur de connexion avec Google: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de connexion avec Google'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future facebookLogin() async {
    final result =
        await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData();
      return userData;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 90),
              SizedBox(height: 20),
              Text(
                "Login",
                style:
                    GoogleFonts.sora(fontSize: 40, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? "L'e-mail ne peut pas être vide." : null,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "E-mail",
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) => value!.length < 8
                      ? "Le mot de passe doit comporter au moins 8 caractères."
                      : null,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Mot de passe",
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      AuthService()
                          .loginWithEmail(
                              _emailController.text, _passwordController.text)
                          .then((value) {

                        print(value["status"]);
                        if (value["status"] == "Login Successful") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Connexion réussie")));

                          print("User type: ${value["userType"]}");

                          // Naviguation en fonction du type d'utilisateur 

                          if (value["userType"] == "Passenger") {
                            Navigator.pushReplacementNamed(
                                context, '/passager');
                          } else if (value["userType"] == "Driver") {
                            Navigator.pushReplacementNamed(
                                context, '/conducteur');
                          }

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              value["status"],
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red.shade400,
                          ));
                        }
                      });
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width * .9,
                child: OutlinedButton(
                  onPressed: () {
                    // Appeler la méthode de connexion avec Google
                    _signInWithGoogle(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/google.png",
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Continuez avec Google",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width * .9,
                child: OutlinedButton(
                  onPressed: () {
                    facebookLogin();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/facebook.png",
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Continuez avec Facebook",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Vous n'avez pas de compte?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text("Inscrivez-vous"),
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
