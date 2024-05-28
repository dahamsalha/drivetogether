import 'dart:io';
import 'package:drivetogether/controllers/auth_service.dart';
import 'package:drivetogether/controllers/trajetService.dart';
import 'package:drivetogether/views/chat_page.dart';
import 'package:drivetogether/views/proposertrajet-page.dart';
import 'package:drivetogether/views/trajet-page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;


class ConducteurDashboard extends StatefulWidget {
  @override
  _ConducteurDashboardState createState() => _ConducteurDashboardState();
}

class _ConducteurDashboardState extends State<ConducteurDashboard> {
  final AuthService _authService = AuthService();
  final TrajetService _trajetService = TrajetService();
  File? _imageFile;
  final _picker = ImagePicker();
  List<Trajet> _trajets = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    bool loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      await _authService.fetchUserName();
      setState(() {});
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  void _showImageSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImageFromGallery();
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  ImageProvider<Object>? _getImageProvider() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else {
      // Image par défaut si aucune image n'est sélectionnée
      return AssetImage('assets/images/photos5.jpg');
    }
  }

  Future<void> _uploadProfileImage() async {
    try {
      String downloadUrl = await _uploadImageToStorage(_imageFile);
      // Mettre à jour l'image de profil dans la base de données (si nécessaire)
      // Exemple : _authService.updateProfileImage(downloadUrl);
      print('Image téléchargée avec succès : $downloadUrl');
    } catch (error) {
      print('Erreur lors du téléchargement de l\'image : $error');
    }
  }

  Future<String> _uploadImageToStorage(File? imageXFile) async {
    try {
      String downloadUrl = "";
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
          .ref()
          .child("ProfileImages")
          .child(fileName);
      fStorage.UploadTask uploadTask =
          storageRef.putFile(File(imageXFile!.path));
      fStorage.TaskSnapshot tasksnapshot =
          await uploadTask.whenComplete(() => {});
      await tasksnapshot.ref.getDownloadURL().then((urlImage) {
        downloadUrl = urlImage;
      });
      return downloadUrl;
    } catch (error) {
      print('Erreur Firebase Storage : $error');
      throw error;
    }
  }

  void _addTrajet(Trajet trajet) {
    setState(() {
      _trajets.add(trajet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conducteur'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Logique des notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset(
              'assets/images/photos4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Contenu de la page
          SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(255, 203, 186, 186).withOpacity(0.5), // Semi-transparent
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _showImageSource(context),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _getImageProvider()!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_authService.userName ?? ''} ${_authService.userLastName ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 12, 12, 12),
                        ),
                      ),
                      Text(
                        'Je suis un conducteur',
                        style: TextStyle(
                          color: Color.fromARGB(255, 10, 9, 9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Text('Voir mon profil'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProposerTrajetPage();
                        },
                      );
                    },
                    child: Text('Proposer un trajet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 225, 227, 229), // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Coins arrondis
                      ),
                      elevation: 5, // Ombre
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProposerTrajetPage(), // Changer ici pour naviguer vers ProposerTrajetPage
                        ),
                      );
                    },
                    child: Text('Voir tous les trajets'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 225, 227, 229), // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Coins arrondis
                      ),
                      elevation: 5, // Ombre
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProposerTrajetPage(), // Changer ici pour naviguer vers ProposerTrajetPage
                        ),
                      );
                    },
                    child: Text('Voir tous les trajets'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 225, 227, 229), // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Coins arrondis
                      ),
                      elevation: 5, // Ombre
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Logique de confirmation de la réservation du passager
                      // Par exemple, envoyer une notification ou mettre à jour l'état de la réservation dans la base de données

                      // Afficher une réponse visuelle à l'utilisateur
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Confirmation de la réservation du passager.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Text('Confirmer la réservation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 233, 236, 233), // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Coins arrondis
                      ),
                      elevation: 5, // Ombre
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Logique de confirmation du paiement
                      // Par exemple, traiter le paiement ou mettre à jour l'état du paiement dans la base de données

                      // Afficher une réponse visuelle à l'utilisateur
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Paiement confirmé.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Text('Confirmer le paiement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 233, 236, 233), // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Coins arrondis
                      ),
                      elevation: 5, // Ombre
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        onTap: (index) {
          // Gérer la navigation vers différentes sections
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ConducteurDashboard(),
  ));
}
