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
  Future<Map<String, dynamic>> loginWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      String userType = userSnapshot.get('driverOrPassenger');
      this.userType = userType;

      return {"status": "Login Successful", "userType": userType};
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
}
