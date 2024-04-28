import 'package:flutter/material.dart';

class Trip {
  String id;
  String departure;
  String destination;
  DateTime date;
  int availableSeats;

  Trip({
    required this.id,
    required this.departure,
    required this.destination,
    required this.date,
    required this.availableSeats,
  });
}
