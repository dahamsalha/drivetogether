import 'dart:io';
import 'package:drivetogether/controllers/auth_service.dart';
import 'package:drivetogether/controllers/trajetService.dart';
import 'package:drivetogether/views/Administrateur_page.dart';
import 'package:drivetogether/views/Resultattrajetrecherche_page.dart';
import 'package:drivetogether/views/chat_page.dart';
import 'package:drivetogether/views/cherchertrajet_page.dart';
import 'package:drivetogether/views/espaceconducteur_page.dart';
import 'package:drivetogether/views/motdepasseoublie_page.dart';
import 'package:drivetogether/views/payment_page.dart'; // Import de la page de paiement
import 'package:drivetogether/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:image_picker/image_picker.dart';

class PassengerDashboard extends StatefulWidget {
  @override
  _PassengerDashboardState createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard> {
  final AuthService _authService = AuthService();
  final TrajetService _trajetService = TrajetService();
  File? _imageFile;
  final _picker = ImagePicker();
  int _selectedIndex = 0;

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
            title: Text('Galerie'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImageFromGallery();
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Caméra'),
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
      return AssetImage('assets/images/photos.jpeg'); // Mettez ici l'image par défaut
    }
  }

  Future<void> _uploadProfileImage() async {
    try {
      String downloadUrl = await _uploadImageToStorage(_imageFile);
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

  void _search() async {
    final List<Map<String, dynamic>> searchResults = await _trajetService.searchTrajets(
      selectedDateTime: DateTime.now(),
      depart: '',
      arrivee: '',
      date: '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrajetSearchResults(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/profile');
        break;
      case 2:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image de fond
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/photos3.jpg'), // Chemin de votre image de fond
              fit: BoxFit.cover, // Ajuste l'image pour couvrir toute la surface
            ),
          ),
        ),
        // Contenu de la page
        Scaffold(
          backgroundColor: Colors.transparent, // Rend le fond du Scaffold transparent
          appBar: AppBar(
            title: Row(
              children: [
                Opacity(
                  opacity: 0.9, // Définit la transparence à 50%
                  child: Image.asset(
                    'assets/images/drivetogether1.jpg', // Chemin de votre logo
                    height: 40,
                  ),
                ),
                SizedBox(width: 20),
                Text('Passager'),
              ],
            ),
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
            backgroundColor: Color.fromARGB(255, 230, 232, 233),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/photos6.jpg'), // Chemin de votre nouvelle image de fond
                      fit: BoxFit.cover, // Ajuste l'image pour couvrir toute la surface
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showImageSource(context),
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
                                'Je suis passager',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                buildActionButtons(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blueGrey,
            onTap: _onItemTapped,
          ),
        ),
      ],
    );
  }

  Widget buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: Text('Modifier le profil'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue, backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChercherTrajetPage()),
            );
          },
          child: Text('Proposer Trajet'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue, backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _search,
          child: Text('Réserver'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue, backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentPage()), // Ajout de la navigation vers la page de paiement
            );
          },
          child: Text('Payer'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue, backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PassengerDashboard(),
    routes: {
      '/signup': (context) => SignUpPage(),
      '/passager': (context) => PassengerDashboard(),
      '/conducteur': (context) => ConducteurDashboard(),
      '/Administrateur': (context) => AdminPage(),
      '/forgot_password': (context) => ForgotPasswordPage(), // Ajout de cette ligne
      '/payment': (context) => PaymentPage(), // Ajout de cette ligne pour la page de paiement
    },
  ));
}
