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
      // Authentifiez l'administrateur directement sans vérifier le mot de passe
      // Vous pouvez remplacer cette logique par ce que vous voulez
      // Par exemple, vous pouvez vérifier si l'adresse e-mail est valide
      // ou si elle correspond à celle d'un administrateur dans une base de données
      
      // Si l'adresse e-mail est celle de l'administrateur, retournez "Login Successful"
      // et définissez le type d'utilisateur comme "admin" ou autre selon vos besoins
      return {"status": "Login Successful", "userType": "admin"};
    } else {
      // Si l'utilisateur n'est pas l'administrateur, procédez normalement
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
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    // logout from google if logged in with google
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }
  }

  // check whether the user is sign in or not
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  // for login with google
  Future<String> continueWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // send auth request
      final GoogleSignInAuthentication gAuth = await googleUser!.authentication;

      // obtain a new creditional
      final creds = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      // sign in with the credentials
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
      String lastName =
          userSnapshot.get('lastName'); // Récupération du nom de famille
      userName = name;
      userLastName = lastName;
      userName = name;
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

}