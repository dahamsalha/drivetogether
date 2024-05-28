import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'background_container.dart'; // Import the BackgroundContainer

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
  String _selectedStatus = "Homme"; // Initial status value
  String _selectedUserType = "Passenger"; // Initial user type value

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
        'status': _selectedStatus,
        'userType': _selectedUserType,
      });

      return "Account Created";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SingleChildScrollView(
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
                      _buildStatusDropdown(),
                      const SizedBox(height: 10),
                      _buildUserTypeDropdown(),
                    ],
                  ),
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
                          if (_selectedUserType == "Passenger") {
                            Navigator.pushReplacementNamed(context, '/passager');
                          } else if (_selectedUserType == "Driver") {
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

  Widget _buildStatusDropdown() {
    return Row(
      children: [
        Icon(Icons.person_2_sharp),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedStatus,
            items: ['Homme', 'Femme'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Statut (Homme ou Femme)',
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez sélectionner un statut';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeDropdown() {
    return Row(
      children: [
        Icon(Icons.directions_car),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedUserType,
            items: ['Driver', 'Passenger'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Type d\'utilisateur (Conducteur ou Passager)',
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedUserType = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez sélectionner un type d\'utilisateur';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
