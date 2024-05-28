import 'package:drivetogether/views/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivetogether/controllers/proposertrajetservice.dart';
import 'package:drivetogether/views/background_container.dart';

class TrajetSearchResults extends StatelessWidget {
  final ProposerTrajetService trajetService = ProposerTrajetService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes trajets'),
      ),
      body: BackgroundContainer(
        child: StreamBuilder<QuerySnapshot>(
          stream: trajetService.getAllTrajets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur lors de la récupération des trajets'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Aucun trajet disponible'));
            }

            final trajets = snapshot.data!.docs;

            return Column(
              children: [
                SizedBox(height: 16.0),
                Text(
                  'Trajets disponibles',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text('${trajets.length} trajets disponibles'),
                SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: trajets.length,
                    itemBuilder: (context, index) {
                      final trajet = trajets[index].data() as Map<String, dynamic>;
                      return TrajetTile(trajet: trajet);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TrajetTile extends StatelessWidget {
  final Map<String, dynamic> trajet;

  TrajetTile({required this.trajet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car, size: 50.0),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Départ: ${trajet['point_depart'] ?? 'N/A'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Destination: ${trajet['destination'] ?? 'N/A'}',
                ),
                SizedBox(height: 8.0),
                Text(
                  'Date: ${trajet['date'] ?? 'N/A'} à ${trajet['heure'] ?? 'N/A'}',
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  },
                  child: Text('Payer'),
                ),
                
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Action lorsque le bouton est pressé
              print('Trajet sélectionné: ${trajet['point_depart']} à ${trajet['destination']}');
            },
            child: Text('Sélectionner'),
          ),
        ],
      ),
    );
  }
}
