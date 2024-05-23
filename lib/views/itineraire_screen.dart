import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart' as geocoding;
import 'package:flutter_google_maps_webservices/directions.dart' as gmaps;

class ItineraireScreen extends StatefulWidget {
  final String depart;
  final String arrivee;

  ItineraireScreen({required this.depart, required this.arrivee});

  @override
  _ItineraireScreenState createState() => _ItineraireScreenState();
}

class _ItineraireScreenState extends State<ItineraireScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  late BitmapDescriptor iconeDepart;
  late BitmapDescriptor iconeArrivee;

  final geocodingApi = geocoding.GoogleMapsGeocoding(apiKey: 'AIzaSyC-OTIP0wqfut_dspRVK-Uam_enFG6q-PE');
  final directionsApi = gmaps.GoogleMapsDirections(apiKey: 'AIzaSyC-OTIP0wqfut_dspRVK-Uam_enFG6q-PE');

  @override
  void initState() {
    super.initState();
    _loadIcons();
  }

  Future<void> _loadIcons() async {
    iconeDepart = await getIconeDepart();
    iconeArrivee = await getIconeArrivee();
  }

  Future<BitmapDescriptor> getIconeDepart() async {
    final bytes = await getBytesFromAsset('assets/images/ligne-de-depart.png');
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<BitmapDescriptor> getIconeArrivee() async {
    final bytes = await getBytesFromAsset('assets/images/ligne-darrivee.png');
    return BitmapDescriptor.fromBytes(bytes);
  }


  Future<Uint8List> getBytesFromAsset(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<gmaps.Location> getLocationFromAddress(String address) async {
    final response = await geocodingApi.searchByAddress(address);
    if (response.isOkay && response.results.isNotEmpty) {
      final result = response.results.first;
      return gmaps.Location(lat: result.geometry.location.lat, lng: result.geometry.location.lng);
    } else {
      throw Exception('Failed to get location for address: $address');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  Future<void> getDirections() async {
    try {
      final originLocation = await getLocationFromAddress(widget.depart);
      final destinationLocation = await getLocationFromAddress(widget.arrivee);

      final response = await directionsApi.directions(
        originLocation,
        destinationLocation,
        travelMode: gmaps.TravelMode.driving,
      );

      if (response.isOkay) {
        final route = response.routes[0];
        final origin = route.legs[0].startLocation;
        final destination = route.legs[0].endLocation;

        setState(() {
          markers.add(Marker(
            markerId: MarkerId('depart'),
            position: LatLng(origin.lat, origin.lng),
            icon: iconeDepart,
          ));
          markers.add(Marker(
            markerId: MarkerId('arrivee'),
            position: LatLng(destination.lat, destination.lng),
            icon: iconeArrivee,
          ));

          final points = decodePolyline(route.overviewPolyline.points);
          polylines.add(Polyline(
            polylineId: PolylineId('itineraire'),
            color: Colors.blue,
            width: 5,
            points: points,
          ));
        });

        mapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(route.bounds.southwest.lat, route.bounds.southwest.lng),
            northeast: LatLng(route.bounds.northeast.lat, route.bounds.northeast.lng),
          ),
          50,
        ));
      } else {
        print('Error: ${response.errorMessage}');
      }
    } catch (e) {
      print('Error getting directions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itinéraire'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Position initiale de la caméra
          zoom: 14.0,
        ),
        markers: markers,
        polylines: polylines,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          getDirections();
        },
      ),
    );
  }
}
