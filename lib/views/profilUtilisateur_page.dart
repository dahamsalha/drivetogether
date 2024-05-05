import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class profilutilisateur extends StatefulWidget {
  @override
  _profilutilisateurState createState() => _profilutilisateurState();
}

class _profilutilisateurState extends State<profilutilisateur> {
  final _formKey = GlobalKey<FormState>();
  late String _name = ''; // Initialize variables
  late String _phone = ''; // Remove _email variable

  @override
  void initState() {
    super.initState();
    // Call a method to retrieve user data when the widget is initialized
    getUserData();
  }

  // Method to retrieve user data from Firestore
  void getUserData() async {
    // Retrieve user data from Firestore
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // Update form fields with user data
    setState(() {
      _name = userSnapshot.get('name');
      _phone = userSnapshot.get('phone');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name, // Set initial value
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _phone, // Set initial value
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                onSaved: (value) => _phone = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Save user profile data to Firebase or local storage
                    // ignore: avoid_print
                    print('Name: $_name, Phone: $_phone');
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}