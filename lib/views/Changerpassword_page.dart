import 'package:flutter/material.dart';

class ChangerPasswordPage extends StatefulWidget {
  @override
  _ChangerPasswordPageState createState() => _ChangerPasswordPageState();
}

class _ChangerPasswordPageState extends State<ChangerPasswordPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le mot de passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de passe actuel'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirmer le nouveau mot de passe'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _changePassword();
              },
              child: Text('Changer le mot de passe'),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    // Validate if passwords match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      // Show error message
      _showErrorDialog('Les mots de passe ne correspondent pas.');
      return;
    }

    // Call your authentication service or API to change the password
    // You can use _currentPasswordController.text and _newPasswordController.text to get the old and new passwords
    // Replace this with your actual logic to change the password

    // After successfully changing the password, you might want to navigate back or show a success message
    // For example:
    Navigator.pop(context); // Navigate back to the previous page
    // Or show a success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Mot de passe changé avec succès!'),
    ));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
