import 'package:drivetogether/controllers/FirebaseService.dart';
import 'package:drivetogether/models/trip.dart';
import 'package:flutter/material.dart';

class ConducteurDashboard extends StatefulWidget {
  @override
  _ConducteurDashboardState createState() => _ConducteurDashboardState();
}

class _ConducteurDashboardState extends State<ConducteurDashboard> {
  List<Trip> _trips = [];
  FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    List<Trip> trips = await _firebaseService.getTrips();
    setState(() {
      _trips = trips;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace Conducteur'),
      ),
      body: _trips.isEmpty
          ? Center(
              child: Text('Aucun trajet proposé'),
            )
          : ListView.builder(
              itemCount: _trips.length,
              itemBuilder: (context, index) {
                return TripItem(
                  trip: _trips[index],
                  onEdit: () {
// Logique pour modifier le trajet
                  },
                  onDelete: () {
                    _deleteTrip(_trips[index]);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
// Naviguer vers l'écran pour ajouter un nouveau trajet
          Navigator.pushNamed(context, '/add_trip');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteTrip(Trip trip) async {
    await _firebaseService.deleteTrip(trip);
    _loadTrips();
  }
}

class TripItem extends StatelessWidget {
  final Trip trip;
  final void Function()? onEdit;
  final void Function()? onDelete;

  TripItem({required this.trip, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${trip.departure} - ${trip.destination}'),
      subtitle: Text('Date: ${trip.date.toString()}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
