import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivetogether/views/Voiture_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'conversation_page.dart'; // Import the ConversationPage widget
import 'preferences_page.dart'; // Import the PreferencesPage widget
import 'avis_page.dart'; // Import the AvisPage widget

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
      });
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
      body: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/photos.jpeg'),
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
                _buildRatingsTab(),
                _buildConversationsTab(),
                _buildVehiclesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesTab() {
    return PreferencesPage(); // Use the PreferencesPage widget here
  }

  Widget _buildRatingsTab() {
    return AvisPage(); // Use the AvisPage widget here
  }

  Widget _buildConversationsTab() {
    return ConversationPage(); // Use the ConversationPage widget here
  }
  
    // Use the Voiturepage  widget here
  

  Widget _buildVehiclesTab() {
     return VoiturePage();
      
    
  }
}