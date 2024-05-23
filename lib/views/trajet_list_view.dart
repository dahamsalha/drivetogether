import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrajetListView extends StatelessWidget {
  final String role;

  const TrajetListView({required this.role, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('trajet').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        var trajets = snapshot.data!.docs;
        return ListView.builder(
          itemCount: trajets.length,
          itemBuilder: (context, index) {
            var trajet = trajets[index];
            return ListTile(
              title: Text('Départ: ${trajet['point_depart']} - Destination: ${trajet['destination']}'),
              subtitle: Text('Date: ${trajet['date']} - Heure: ${trajet['heure']}'),
            );
          },
        );
      },
    );
  }
}
