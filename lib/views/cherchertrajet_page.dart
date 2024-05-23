import 'package:drivetogether/views/MapScreen.dart';
import 'package:drivetogether/views/espacepassager_page.dart';
import 'package:flutter/material.dart';
import 'package:drivetogether/controllers/trajetService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class ChercherTrajetPage extends StatefulWidget {
  @override
  _ChercherTrajetPageState createState() => _ChercherTrajetPageState();
}

class _ChercherTrajetPageState extends State<ChercherTrajetPage> {
  final TrajetService _trajetService = TrajetService();
  TextEditingController _departureController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  LatLng? _selectedDepartureLocation;
  LatLng? _selectedArrivalLocation;

  String _departurePlaceName = 'Select departure location';
  String _arrivalPlaceName = 'Select arrival location';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de Trajets'),
        backgroundColor: Colors.blueGrey,
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
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueGrey, // foreground
              ),
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
              child: Text('Sélectionner une date'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueGrey, // foreground
              ),
            ),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('Sélectionner l\'heure'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueGrey, // foreground
              ),
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
    final List<Map<String, dynamic>> searchResults = await _trajetService.searchTrajets(
      selectedDateTime: _selectedDateTime,
      depart: _departurePlaceName,
      arrivee: _arrivalPlaceName,
      date: '',
    );

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
          picked.hour,
          picked.minute,
        );
      });
    }
  }

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
  }
}
