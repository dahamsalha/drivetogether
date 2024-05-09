import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _selectedLocation = LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Location'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _selectedLocation,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: _onMapTap,
        markers: {
          Marker(
            markerId: MarkerId('selected-location'),
            position: _selectedLocation,
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _confirmLocation(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _confirmLocation(BuildContext context) {
    Navigator.pop(context, _selectedLocation);
  }
}
