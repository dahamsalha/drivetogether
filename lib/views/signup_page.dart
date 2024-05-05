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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String _gender = "Homme";
  String _smoker = "Non";
  String _hasPets = "Non";
  String _driverOrPassenger = "Passenger";

  Future<String> _signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Mise à jour du profil de l'utilisateur avec les nouveaux champs
      await userCredential.user!.updateProfile(
          displayName:
              '${_firstNameController.text} ${_lastNameController.text}');

      // Enregistrement des autres champs dans Firebase Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'gender': _gender,
        'smoker': _smoker,
        'hasPets': _hasPets,
        'driverOrPassenger': _driverOrPassenger,
      });

      return "Account Created";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Genre',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Homme',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    Text('Homme'),
                    Radio<String>(
                      value: 'Femme',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    Text('Femme'),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Smoker ? ',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Oui',
                      groupValue: _smoker,
                      onChanged: (value) {
                        setState(() {
                          _smoker = value!;
                        });
                      },
                    ),
                    Text('Oui'),
                    Radio<String>(
                      value: 'Non',
                      groupValue: _smoker,
                      onChanged: (value) {
                        setState(() {
                          _smoker = value!;
                        });
                      },
                    ),
                    Text('Non'),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Pets?',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Oui',
                      groupValue: _hasPets,
                      onChanged: (value) {
                        setState(() {
                          _hasPets = value!;
                        });
                      },
                    ),
                    Text('Oui'),
                    Radio<String>(
                      value: 'Non',
                      groupValue: _hasPets,
                      onChanged: (value) {
                        setState(() {
                          _hasPets = value!;
                        });
                      },
                    ),
                    Text('Non'),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Driver or Passenger',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Passenger',
                      groupValue: _driverOrPassenger,
                      onChanged: (value) {
                        setState(() {
                          _driverOrPassenger = value!;
                        });
                      },
                    ),
                    Text('Passenger'),
                    Radio<String>(
                      value: 'Driver',
                      groupValue: _driverOrPassenger,
                      onChanged: (value) {
                        setState(() {
                          _driverOrPassenger = value!;
                        });
                      },
                    ),
                    Text('Driver'),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUp().then((result) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(result),
                        ));
                        if (result == "Account Created") {
                          print( 'result: $result');
                          
                          if (_driverOrPassenger == "Passenger") {
                            Navigator.pushReplacementNamed(
                                context, '/passager');
                          } else if (_driverOrPassenger == "Driver") {
                            Navigator.pushReplacementNamed(
                                context, '/conducteur');
                          }
                        }
                      });
                    }
                    print( 'userType: $_driverOrPassenger');
                    
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SignUpPage(),
      // Ajoutez d'autres routes au besoin
    },
  ));
}
