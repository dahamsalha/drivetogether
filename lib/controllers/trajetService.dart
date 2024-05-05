import 'package:cloud_firestore/cloud_firestore.dart';

class TrajetService {
  final CollectionReference trajetCollection =
      FirebaseFirestore.instance.collection('trajets');

  // Méthode pour ajouter un nouveau trajet à Firestore
  Future<void> addTrajet({
    required String depart,
    required String arrivee,
    required String date,
    required String heure,
    required String nbPlaces,
    required String prix,
    required String message,
  }) async {
    try {
      await trajetCollection.add({
         'Depart': depart,
        'Arrivee': arrivee,
        'Date de depart': date,
        'Heure': heure,
        'Nombre de places': nbPlaces,
        'Prix': prix,
        'message':message,
        // Vous pouvez ajouter d'autres champs du trajet ici
      });
      print('Trajet ajouté avec succès.');
    } catch (e) {
      print('Erreur lors de l\'ajout du trajet: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllTrajets() async {
    try {
      QuerySnapshot querySnapshot = await trajetCollection.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des trajets: $e');
      return [];
    }
  }
}
