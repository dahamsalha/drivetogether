import 'package:drivetogether/views/MapScreen.dart';
import 'package:drivetogether/views/trajet-page.dart';
import 'package:flutter/material.dart';
import 'package:drivetogether/controllers/trajetService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import your TrajetDetails screen

import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class PassengerDashboard extends StatefulWidget {
  @override
  _PassengerDashboardState createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard> {
  final TrajetService _trajetService = TrajetService();
  TextEditingController _departureController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  LatLng? _selectedDepartureLocation;
  LatLng? _selectedArrivalLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace Passager : Recherche de trajets'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildDestinationHeader(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _search,
              child: Text('Rechercher'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDestinationHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Champs de départ et d\'arrivée',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        buildDepartureLocation(),
        SizedBox(height: 10),
        buildArrivalLocation(),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _selectDate,
              child: Text(
                '$_selectedDateTime',
              ),
            ),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('Sélectionner l\'heure'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDepartureLocation() {
    return GestureDetector(
      onTap: _selectDepartureLocation,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(width: 10),
            Text(
              _selectedDepartureLocation != null
                  ? _departurePlaceName
                  : 'Select Departure Location',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildArrivalLocation() {
    return GestureDetector(
      onTap: _selectArrivalLocation,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(width: 10),
            Text(
              _selectedArrivalLocation != null
                  ? _arrivalPlaceName
                  : 'Select Arrival Location',
            ),
          ],
        ),
      ),
    );
  }

  void _search() async {
    // Perform search based on selected date, time, departure, and destination
    final List<Map<String, dynamic>> searchResults = await _trajetService.searchTrajets(
      selectedDateTime: _selectedDateTime,
      depart: _departurePlaceName,
      arrivee: _arrivalPlaceName,
      date: '',

    );

    // Navigate to the search results page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrajetSearchResults(searchResults: searchResults),
      ),
    );
  }
  

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = picked;
      });
      print(_selectedDateTime);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
        );
      });
    }
  }

  String _departurePlaceName = 'Select departure location';
  String _arrivalPlaceName = 'Select arrival location';

 Future<String> getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return place.administrativeArea ?? 'Unknown state';
      } else {
        return 'Unknown state';
      }
    } catch (e) {
      return 'Failed to get state name';
    }
  }

  void _selectDepartureLocation() async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    if (selectedLocation != null) {
      setState(() {
        _selectedDepartureLocation = selectedLocation;
      });
      try {
        String placeName = await getPlaceName(selectedLocation.latitude, selectedLocation.longitude);
        setState(() {
          _departurePlaceName = placeName;
        });
      } catch (e) {
        print('Failed to get place name: $e');
      }
      print(_departurePlaceName);
    }
  }

  void _selectArrivalLocation() async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    if (selectedLocation != null) {
      setState(() {
        _selectedArrivalLocation = selectedLocation;
      });
      try {
        String placeName = await getPlaceName(selectedLocation.latitude, selectedLocation.longitude);
        setState(() {
          _arrivalPlaceName = placeName;
        });
      } catch (e) {
        print('Failed to get place name: $e');
      }
    }
    print(_arrivalPlaceName);
  }
}

class TrajetSearchResults extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;

  TrajetSearchResults({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de la recherche'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var trajet = searchResults[index];
          return ListTile(
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
          );
        },
      ),
    );
  }
}
