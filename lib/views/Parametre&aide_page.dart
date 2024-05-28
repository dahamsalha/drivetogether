import 'package:drivetogether/views/changement_languepage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres & Aide'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/jaune1.jpg'), // Assurez-vous d'ajouter l'image à votre dossier assets
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Modification de mot de passe'),
              subtitle: Text('Modifiez votre mot de passe si besoin.'),
              onTap: () {
                Navigator.pushNamed(context, '/change_password'); // Navigate to password change page
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Changer de langue'),
              subtitle: Text('drivetogether disponible en Francais & Anglais.'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageChangePage()),
                ); // Navigate to language change page
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Notez l’application'),
              subtitle: Text('On mérite 5 étoiles, non ? :)'),
              onTap: () {
                // Navigate to app rating page
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Conditions Générales'),
              subtitle: Text('Lecture des CGU'),
              onTap: () {
                // Navigate to terms and conditions page
              },
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Politique de Confidentialité'),
              subtitle: Text('Lecture de la Politique de confidentialité'),
              onTap: () {
                // Navigate to privacy policy page
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Nous contacter'),
              subtitle: Text('Envoyez nous un email, ca nous fait plaisir !'),
              onTap: () {
                // Navigate to contact page
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Supprimer compte'),
              subtitle: Text('Remplir le formulaire'),
              onTap: () {
                // Navigate to delete account page
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Se déconnecter'),
              subtitle: Text('drivetogether  you soon'),
              onTap: () {
                // Log out user
              },
            ),
          ],
        ),
      ),
    );
  }
}
