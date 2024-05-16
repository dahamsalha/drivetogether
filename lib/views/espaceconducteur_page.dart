import 'dart:io';
import 'package:drivetogether/controllers/auth_service.dart';
import 'package:drivetogether/controllers/trajetService.dart';
import 'package:drivetogether/views/chat_page.dart';
import 'package:drivetogether/views/proposertrajet-page.dart';
import 'package:drivetogether/views/traject_screen.dart';
import 'package:drivetogether/views/trajet-page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:image_picker/image_picker.dart';

class ConducteurDashboard extends StatefulWidget {
  @override
  _ConducteurDashboardState createState() => _ConducteurDashboardState();
}

class _ConducteurDashboardState extends State<ConducteurDashboard> {
  final AuthService _authService = AuthService();
  final TrajetService _trajetService = TrajetService();
  File? _imageFile;
  final _picker = ImagePicker();

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
      return AssetImage('assets/images/default-avatar.jpeg');
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>_showImageSource(context),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _getImageProvider(),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_authService.userName ?? ''} ${_authService.userLastName ?? ''}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser!.email ?? '',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Dans votre écran d'accueil ou tout autre widget
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Text('Voir mon profil'),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24,
              thickness: 2,
              color: Colors.grey,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return trajetScreen();
                  },
                );
              },
              child: Text('Proposer un trajet'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FutureBuilder(
                      future: _trajetService.getAllTrajets(),
                      builder: (context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                'Une erreur s\'est produite: ${snapshot.error}'),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('Aucun trajet trouvé.'),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var trajet = snapshot.data![index];
                            return ListTile(
                              title: Text('Départ: ${trajet['Depart']}'),
                              subtitle: Text('Arrivée: ${trajet['Arrivee']}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TrajetDetails(trajet: trajet),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
              child: Text('Voir tous les trajets'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ConducteurDashboard(),
  ));
}
