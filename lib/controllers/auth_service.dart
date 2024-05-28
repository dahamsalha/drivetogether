import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  String? userType;
  String? userName;
  String? userLastName;

  // create new account using email password method
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // login with email password method
  Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    try {
      // Vérifiez d'abord si l'utilisateur essaye de se connecter en tant qu'administrateur
      if (email == "admin@gmail.com") {
        return {"status": "Login Successful", "userType": "admin"};
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        String userId = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        
        if(userSnapshot.exists) {
          String userType = userSnapshot.get('driverOrPassenger');
          this.userType = userType;
          return {"status": "Login Successful", "userType": userType};
        } else {
          return {"status": "User document not found", "userType": null};
        }
      }
    } on FirebaseAuthException catch (e) {
      return {"status": e.message.toString(), "userType": null};
    }
  }

  // logout the user
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }
  }

  // check whether the user is signed in or not
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  // for login with google
  Future<String> continueWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await googleUser!.authentication;
      final creds = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(creds);
      return "Google Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<void> fetchUserName() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      String name = userSnapshot.get('firstName');
      String lastName = userSnapshot.get('lastName');
      userName = name;
      userLastName = lastName;
    } catch (e) {
      print('Erreur lors de la récupération du nom d\'utilisateur: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<Map<String, dynamic>> users = [];
      userSnapshot.docs.forEach((doc) {
        users.add(doc.data() as Map<String, dynamic>);
      });
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  // reset password method
  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Password Reset Email Sent";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // check if user is remembered
  Future<bool> isRemembered() async {
    // Logic to check if the user is remembered (e.g., using SharedPreferences)
    // This is just a placeholder implementation.
    return false;
  }

  // save user credentials for remember me functionality
  Future<void> saveUserCredentials(String email, String password) async {
    // Logic to save the user credentials securely (e.g., using SharedPreferences)
    // This is just a placeholder implementation.
  }
}
