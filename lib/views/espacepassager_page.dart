import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerDashboard extends StatefulWidget {
  @override
  _PassengerDashboardState createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  TextEditingController _departureController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _departureController.text = "${position.latitude}, ${position.longitude}";
      _destinationController.text =
          "${position.latitude}, ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace Passager : Recherche de trajets'),
      ),
      body: Column(
        children: [
          DestinationHeader(
            pickupController: _departureController,
            destinationController: _destinationController,
            onBack: () {
              // Handle back action
            },
            onChooseOnMap: () {
              _navigateToMapScreen();
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text('Sélectionner une date'),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text('Sélectionner l\'heure'),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _search();
            },
            child: Text('Rechercher'),
          ),
          Expanded(
            child: _currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 12.0,
                    ),
                    onMapCreated: (controller) {
                      setState(() {
                        _mapController = controller;
                      });
                    },
                    markers: _buildMarkers(),
                    onTap: _onMapTap,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call function to handle navigation
        },
        child: Icon(Icons.navigation),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};
    // Add marker for departure
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: MarkerId('Departure'),
          position: _currentPosition!,
          infoWindow: InfoWindow(title: 'Départ'),
        ),
      );
    }
    return markers;
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _destinationController.text =
          '${position.latitude}, ${position.longitude}';
    });
  }

  void _navigateToMapScreen() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );

    if (selectedLocation != null) {
      _destinationController.text =
          '${selectedLocation.latitude}, ${selectedLocation.longitude}';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateTime)
      setState(() {
        _selectedDateTime = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
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

  void _search() {
    // Perform search based on selected date, time, departure, and destination
    // Implement your search logic here
    print('Searching for trips...');
    print('Date: $_selectedDateTime');
    print('Departure: ${_departureController.text}');
    print('Destination: ${_destinationController.text}');
  }
}

class DestinationHeader extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController destinationController;
  final VoidCallback onBack;
  final VoidCallback onChooseOnMap;

  const DestinationHeader({
    required this.pickupController,
    required this.destinationController,
    required this.onBack,
    required this.onChooseOnMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: onBack,
              ),
              Text(
                'Champs de départ et d\'arrivée',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      buildTextField(
                        controller: pickupController,
                        prefixIcon: Icon(
                          Icons.boy,
                          color: Colors.blue,
                        ),
                        hintText: 'Enter Pickup Location...',
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.cyan,
                        indent: 20,
                        endIndent: 20,
                      ),
                      buildTextField(
                        controller: destinationController,
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.orangeAccent,
                        ),
                        hintText: 'Enter Destination...',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildIconContainer(
                      icon: Icon(Icons.map),
                      text: 'Choose on Map',
                      onTap: onChooseOnMap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required Icon prefixIcon,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      onChanged: (text) {},
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        border: InputBorder.none,
        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  controller.clear();
                },
                child: Icon(Icons.clear),
              )
            : null,
      ),
    );
  }

  Widget buildIconContainer(
      {required Icon icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon.icon,
              color: Colors.black,
              size: 20,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Destination'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Initial position (dummy values)
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: _onMapTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get the selected location and pass it back to the previous screen
          _getSelectedLocation(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void _onMapTap(LatLng location) {
    // Update the map marker position when the user taps on the map
    setState(() {
      // Update marker position
    });
  }

  void _getSelectedLocation(BuildContext context) async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds latLngBounds = await controller.getVisibleRegion();

    // Calculate the center of the bounds
    double latitude =
        (latLngBounds.northeast.latitude + latLngBounds.southwest.latitude) / 2;
    double longitude =
        (latLngBounds.northeast.longitude + latLngBounds.southwest.longitude) /
            2;

    LatLng center = LatLng(latitude, longitude);

    // Perform reverse geocoding
    //var googleGeocoding = GoogleGeocoding("AIzaSyC-OTIP0wqfut_dspRVK-Uam_enFG6q-PE");
   // var result = await googleGeocoding.geocoding.getReverse(center);

    // Pass the selected location back to the previous screen
    Navigator.pop(context, center);
}
}

void main() {
  runApp(MaterialApp(
    home: PassengerDashboard(),
  ));
}
