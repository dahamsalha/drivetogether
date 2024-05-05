import 'package:flutter/material.dart';
import 'package:drivetogether/controllers/trajetService.dart';

class Trajet extends StatefulWidget {
  final String depart;
  final String arrivee;
  final String date;
  final String heure;
  final String nbPlaces;
  final String prix;
  final String message;
  final String driver_id;

  Trajet({
    required this.depart,
    required this.arrivee,
    required this.date,
    required this.heure,
    required this.nbPlaces,
    required this.prix,
    required this.message,
    required this.driver_id,
  });

  @override
  _TrajetState createState() => _TrajetState();
}

class _TrajetState extends State<Trajet> {
  final TrajetService _trajetService = TrajetService();

  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: Text('Liste des trajets'),
      ),
      body: FutureBuilder(
        future: _trajetService.getAllTrajets(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur s\'est produite: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Aucun trajet trouvé.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var trajet = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text('Départ: ${trajet['Depart']}'),
                  subtitle: Text('Arrivée: ${trajet['Arrivee']}'),
                  onTap: () {
 Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrajetDetails(trajet: trajet),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class TrajetDetails extends StatelessWidget {
  final Map<String, dynamic> trajet;

  TrajetDetails({required this.trajet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du trajet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Départ: ${trajet['Depart']}'),
            Text('Arrivée: ${trajet['Arrivee']}'),
            Text('Date: ${trajet['Date de depart']}'),
            Text('Heure: ${trajet['Heure']}'),
            Text('Nombre de place: ${trajet['Nombre de places']}'),
            Text('Prix: ${trajet['Prix']}'),
            Text('Message: ${trajet['message']}'),
          ],
        ),
     ),
);
}
}