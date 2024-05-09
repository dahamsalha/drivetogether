import 'package:drivetogether/views/trajet-page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivetogether/controllers/auth_service.dart';
import 'package:drivetogether/views/ProposerTrajetForm_page.dart';
import 'package:drivetogether/controllers/trajetService.dart';
import 'package:drivetogether/views/chat_page.dart'; // Assurez-vous de créer cette page pour le chat

class ConducteurDashboard extends StatefulWidget {
  @override
  _ConducteurDashboardState createState() => _ConducteurDashboardState();
}

class _ConducteurDashboardState extends State<ConducteurDashboard> {
  final TrajetService _trajetService = TrajetService();
  final AuthService _authService = AuthService();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/drivetogether1.jpg'), // Chemin vers votre logo
        ), 
        title: Text(' Conducteur'),
        backgroundColor: Color.fromARGB(255, 100, 177, 245),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Logique pour les notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()), // Navigue vers la page de chat
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Votre code existant pour l'image de profil et les informations de l'utilisateur
          AppBar(
              backgroundColor:
                  Colors.white, // Changement de la couleur de l'AppBar
              automaticallyImplyLeading: false,
              title: Text(
                'DriveTogether',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.black, // Changement de la couleur du texte
                  letterSpacing: 0,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Colors.black, // Changement de la couleur de l'icône
                    size: 30,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ],
              centerTitle: false,
              elevation: 0,
            ),
            Container(
              height: 200,
              child: Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1516862523118-a3724eb136d7?w=1280&h=720',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 1),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 16),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors
                              .blue, // Changement de la couleur du conteneur
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1520932767681-47fc69dd54e5?w=512&h=512',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_authService.userName ?? ''} ${_authService.userLastName ?? ''}',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email ?? '',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Colors.grey, // Changement de la couleur du texte
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24,
              thickness: 2,
              color: Colors.grey,
            ),
            // Insert the ElevatedButton with displayTripDetails function here
            ElevatedButton(
              onPressed: () {
                // Show the form to propose a new trip
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ProposerTrajetForm();
                  },
                );
              },
              child: Text('Proposer un trajet'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                textStyle: TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Function to display trip details
                void displayTripDetails() {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder(
                        future: _trajetService.getAllTrajets(),
                        builder: (context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
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
                }

                // Call the function to display trip details
                displayTripDetails();
              },
              child: Text('Voir tous les trajets'),
            ),
          ],
        ),
      ),
    );
  }
}
