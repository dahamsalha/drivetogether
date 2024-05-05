import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivetogether/models/trip.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Trip>> getTrips() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('conducteurs') // Collection des conducteurs
        .get();
    List<Trip> allTrips = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      QuerySnapshot tripsSnapshot =
          await doc.reference.collection('trips').get();
      List<Trip> trips = tripsSnapshot.docs.map((tripDoc) {
        return Trip(
          id: tripDoc.id,
          departure: tripDoc['departure'],
          destination: tripDoc['destination'],
          date: tripDoc['date'].toDate(),
          availableSeats: tripDoc['availableSeats'],
        );
      }).toList();
      allTrips.addAll(trips);
    }
    return allTrips;
  }

  Future<void> addTrip(Trip trip) async {
    await _firestore.collection('conducteurs').doc().collection('trips').add({
      'departure': trip.departure,
      'destination': trip.destination,
      'date': trip.date,
      'availableSeats': trip.availableSeats,
    });
  }

  Future<void> deleteTrip(Trip trip) async {
    await _firestore
        .collection('conducteurs')
        .doc()
        .collection('trips')
        .doc(trip.id)
        .delete();
  }
}
