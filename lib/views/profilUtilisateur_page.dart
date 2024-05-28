import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivetogether/views/Avis_conducteur_page.dart';
import 'package:drivetogether/views/Avis_passager_page.dart';
import 'package:drivetogether/views/background_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'conversation_page.dart';
import 'preferences_page.dart';
import 'voiture_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String driverOrPassenger = '';
  String firstName = '';
  String lastName = '';
  String gender = '';
  String phoneNumber = '';
  bool hasPets = false;
  bool smoker = false;
  String profileImageUrl = 'assets/images/photos.jpeg';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool isDriver = false; // Variable pour vérifier si l'utilisateur est un conducteur
  bool isPassenger = false; // Variable pour vérifier si l'utilisateur est un passager

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    getUserPreferences();
  }

Future<void> getUserPreferences() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      setState(() {
        driverOrPassenger = data?['driverOrPassenger'] ?? '';
        firstName = data?['firstName'] ?? '';
        lastName = data?['lastName'] ?? '';
        gender = data?['gender'] ?? '';
        phoneNumber = data?['phoneNumber'] ?? '';
        hasPets = data?['hasPets'] == 'Oui';
        smoker = data?['smoker'] == 'Oui';
        profileImageUrl = data?['profileImageUrl'] ?? 'assets/images/photos.jpeg';

        // Mettre à jour les rôles de l'utilisateur
        isDriver = driverOrPassenger.toLowerCase() == 'conducteur';
        isPassenger = driverOrPassenger.toLowerCase() == 'passager';
      });
    }
  }
}


  Future<void> updateUserPreferences() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'driverOrPassenger': driverOrPassenger,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'hasPets': hasPets ? 'Oui' : 'Non',
        'smoker': smoker ? 'Oui' : 'Non',
        'profileImageUrl': profileImageUrl,
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await _uploadProfileImage();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await _uploadProfileImage();
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
    } else if (profileImageUrl.startsWith('assets/')) {
      return AssetImage(profileImageUrl);
    } else {
      return NetworkImage(profileImageUrl);
    }
  }

  Future<void> _uploadProfileImage() async {
    try {
      String downloadUrl = await _uploadImageToStorage(_imageFile);
      setState(() {
        profileImageUrl = downloadUrl;
      });
      await updateUserPreferences();
      print('Image téléchargée avec succès : $downloadUrl');
    } catch (error) {
      print('Erreur lors du téléchargement de l\'image : $error');
    }
  }

  Future<String> _uploadImageToStorage(File? imageFile) async {
    try {
      String downloadUrl = "";
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
          .ref()
          .child("ProfileImages")
          .child(fileName);
      fStorage.UploadTask uploadTask = storageRef.putFile(File(imageFile!.path));
      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      await taskSnapshot.ref.getDownloadURL().then((urlImage) {
        downloadUrl = urlImage;
      });
      return downloadUrl;
    } catch (error) {
      print('Erreur Firebase Storage : $error');
      throw error;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: BackgroundContainer( // Utilisez le widget personnalisé ici
        child: Column(

        children: [
          GestureDetector(
            onTap: () => _showImageSource(context),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _getImageProvider(),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: index < 3 ? Colors.amber : Colors.grey,
              );
            }),
          ),
          SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Préférences'),
              Tab(text: 'Avis'),
              Tab(text: 'Conversation'),
              Tab(text: 'Voitures'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPreferencesTab(),
                _buildRatingsTab(context),
                _buildConversationsTab(),
                _buildVehiclesTab(),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildPreferencesTab() {
    return PreferencesPage();
  }

 Widget _buildRatingsTab(BuildContext context) {
  return Column(
    children: [
      ListTile(
        title: Text('Avis du conducteur sur le passager'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          if (!isDriver) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvisConducteurPage()),
            );
          }
        },
        enabled: !isDriver, // Disable the ListTile if the user is a driver
      ),
      ListTile(
        title: Text('Avis du passager sur le conducteur'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          if (!isPassenger) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvisPassagerPage()),
            );
          }
        },
        enabled: !isPassenger, // Disable the ListTile if the user is a passenger
      ),
    ],
  );
}

  Widget _buildConversationsTab() {
    return ConversationPage();
  }

  Widget _buildVehiclesTab() {
    return VoiturePage();
  }
}
