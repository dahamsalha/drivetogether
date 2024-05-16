import 'package:drivetogether/controllers/proposertrajetservice.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListeTrajets extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ListeTrajetsState createState() => _ListeTrajetsState();
}

class _ListeTrajetsState extends State<ListeTrajets> {
  final ProposerTrajetService _proposertrajetservice = ProposerTrajetService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _proposertrajetservice.getTrajets(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Vérifiez si snapshot.data est null avant d'accéder à docs
        if (snapshot.data == null) {
          return Text('Aucun trajet trouvé');
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['destination']),
              subtitle: Text('Date: ${data['date']} Heure: ${data['heure']}'),
              // Ajoutez d'autres détails ici
            );
          }).toList(),
        );
      },
    );
  }
}
