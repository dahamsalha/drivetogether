import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivetogether/models/trip.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Trip>> getTrips() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('conducteurs')
        .doc('id_pilote')
        .collection('trips')
        .get();
    return querySnapshot.docs.map((doc) {
      return Trip(
        id: doc.id,
        departure: doc['departure'],
        destination: doc['destination'],
        date: doc['date'].toDate(),
        availableSeats: doc['availableSeats'],
      );
    }).toList();
  }

  Future<void> addTrip(Trip trip) async {
    await _firestore
        .collection('conducteurs')
        .doc('id_pilote')
        .collection('trips')
        .add({
      'departure': trip.departure,
      'destination': trip.destination,
      'date': trip.date,
      'availableSeats': trip.availableSeats,
    });
  }

  Future<void> deleteTrip(Trip trip) async {
    await _firestore
        .collection('conducteurs')
        .doc('id_pilote')
        .collection('trips')
        .doc(trip.id)
        .delete();
  }
}
