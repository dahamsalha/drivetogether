import 'package:cloud_firestore/cloud_firestore.dart';

class ProposerTrajetService {
  final CollectionReference trajetCollection =
      FirebaseFirestore.instance.collection('trajet');

  Future<void> addTrajet({
    required String allerRetour,
   
    required String cotisation,
    required String date,
    required String destination,
    required String heure,
    required String placesDisponibles,
    required String pointDepart,
    required String typeTrajet,
  }) async {
    try {
      await trajetCollection.add({
        'aller_retour': allerRetour,
       
        'cotisation': cotisation,
        'date': date,
        'destination': destination,
        'heure': heure,
        'place de disponible': placesDisponibles,
        'point_depart': pointDepart,
        'type_trajet': typeTrajet,
      });
      print('Trajet ajouté avec succès.');
    } catch (e) {
      print('Erreur lors de l\'ajout du trajet: $e');
    }
  }

  Stream<QuerySnapshot> getTrajets() {
    return trajetCollection.snapshots();
  }

  Future<void> updateTrajet(String id, Map<String, dynamic> updates) {
    return trajetCollection.doc(id).update(updates);
  }

  Future<void> deleteTrajet(String id) {
    return trajetCollection.doc(id).delete();
  }

  Future<DocumentSnapshot> getTrajetById(String id) {
    return trajetCollection.doc(id).get();
  }

   Stream<QuerySnapshot> getTrajetsByUser(String userId) {
    return trajetCollection.where('userId', isEqualTo: userId).snapshots();
  }

  Stream<QuerySnapshot> getAllTrajets() {
    return FirebaseFirestore.instance
        .collection('trajet') // Assuming 'trajets' is the collection where trips are stored
        .snapshots();
  }
}