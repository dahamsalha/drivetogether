import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

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
        'message': message,
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

  // Méthode pour rechercher des trajets dans Firestore
  Future<List<Map<String, dynamic>>> searchTrajets({
    required String depart,
    required String arrivee,
    required String date,
    required DateTime selectedDateTime,
  }) async {
    try {
      QuerySnapshot querySnapshot = await trajetCollection
          .where('Depart', isEqualTo: depart)
          .where('Arrivee', isEqualTo: arrivee) 
           .where('Depart', isEqualTo: selectedDateTime) 
          .get();
          print('Depart: $depart , Arrivee:$arrivee');
         
          
          

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erreur lors de la recherche des trajets: $e');
      return [];
    }
  }

  enregistrerTrajet(Map<String, dynamic> value) {}
  Future<void> proposerTrajet(Map<String, dynamic> trajetData) async {
    try {
      await trajetCollection.add(trajetData);
      print('Trajet proposé avec succès.');
    } catch (e) {
      print('Erreur lors de la proposition du trajet: $e');
    }
  }
}

