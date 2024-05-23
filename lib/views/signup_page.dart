import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String _userType = "Passenger";

  Future<String> _signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await userCredential.user!.updateProfile(
          displayName:
              '${_firstNameController.text} ${_lastNameController.text}');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'status': _statusController.text,
        'userType': _userType,
      });

      return "Account Created";
    } catch (e) {
      return e.toString();
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
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(Icons.person, size: 60, color: Color.fromARGB(255, 244, 242, 242)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.yellow,
                      child: Icon(Icons.camera_alt, size: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_firstNameController, "Nom et Prénom", Icons.person),
                    const SizedBox(height: 10),
                    _buildTextField(_addressController, "Adresse", Icons.location_on),
                    const SizedBox(height: 10),
                    _buildTextField(_emailController, "E-mail", Icons.email),
                    const SizedBox(height: 10),
                    _buildTextField(_passwordController, "Mot de passe", Icons.lock, obscureText: true),
                    const SizedBox(height: 10),
                    _buildTextField(_statusController, "Statut (Homme ou Femme)", Icons.person_2_sharp),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUserTypeButton("CONDUCTEUR", "Driver"),
                  const SizedBox(width: 10),
                  _buildUserTypeButton("PASSAGER", "Passenger"),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _signUp().then((result) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(result),
                      ));
                      if (result == "Account Created") {
                        if (_userType == "Passenger") {
                          Navigator.pushReplacementNamed(context, '/passager');
                        } else if (_userType == "Driver") {
                          Navigator.pushReplacementNamed(context, '/conducteur');
                        }
                      }
                    });
                  }
                },
                child: Text("S'inscrire"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer $label';
        }
        return null;
      },
    );
  }

  Widget _buildUserTypeButton(String label, String userType) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _userType = userType;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: _userType == userType ? Colors.black : Color.fromARGB(255, 13, 1, 1), backgroundColor: _userType == userType ? Color.fromARGB(255, 105, 184, 102) : const Color.fromARGB(255, 221, 10, 10),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(label),
    );
  }
}
