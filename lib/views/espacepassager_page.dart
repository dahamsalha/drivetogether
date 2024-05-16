import 'package:drivetogether/views/MapScreen.dart';
import 'package:drivetogether/views/trajet-page.dart';
import 'package:flutter/material.dart';
import 'package:drivetogether/controllers/trajetService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import your TrajetDetails screen

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
                  ? 'Departure Location Selected'
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
                  ? 'Arrival Location Selected'
                  : 'Select Arrival Location',
            ),
          ],
        ),
      ),
    );
  }

  void _search() async {
    // Perform search based on selected date, time, departure, and destination
    final List<Map<String, dynamic>> searchResults =
        await _trajetService.searchTrajets(
      selectedDepartureLocation: _selectedDepartureLocation,
      selectedArrivalLocation: _selectedArrivalLocation,
      selectedDateTime: _selectedDateTime,
      depart: '',
      arrivee: '',
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

  void _selectDepartureLocation() async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    if (selectedLocation != null) {
      setState(() {
        _selectedDepartureLocation = selectedLocation;
      });
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
    }
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
        backgroundColor: Colors.blueGrey,
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

void main() {
  runApp(MaterialApp(
    home: PassengerDashboard(),
  ));
}
