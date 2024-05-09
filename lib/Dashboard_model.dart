import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardModel with ChangeNotifier {
  LatLng? currentPosition;
  bool isLoading = true;

  DashboardModel() {
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition = LatLng(position.latitude, position.longitude);
      isLoading = false;
      notifyListeners();
    } catch (e) {
    // Ici, vous pouvez gérer l'erreur comme vous le souhaitez
    // Par exemple, afficher une alerte à l'utilisateur ou définir une position par défaut
    isLoading = false;
    currentPosition = LatLng(0.0, 0.0); // Position par défaut ou dernière position connue
    notifyListeners();
    // Vous pouvez également enregistrer l'erreur dans votre console ou système de suivi des erreurs
    print('Une erreur est survenue lors de la récupération de la localisation : $e');
  }
}

  void navigateToNextScreen(BuildContext context) {
    // Implémentez la logique pour naviguer vers l'écran suivant
    // Par exemple, ouvrir un nouvel écran de détails de trajet
  }

  // Ajoutez d'autres méthodes pour gérer les actions de l'utilisateur, comme la recherche de trajets
}
