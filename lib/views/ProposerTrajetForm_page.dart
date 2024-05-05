import 'package:flutter/material.dart';
import 'package:drivetogether/controllers/trajetService.dart';

class ProposerTrajetForm extends StatefulWidget {
  @override
  _ProposerTrajetFormState createState() => _ProposerTrajetFormState();
}

class _ProposerTrajetFormState extends State<ProposerTrajetForm> {
  final _formKey = GlobalKey<FormState>();
  final _trajetService = TrajetService();
  late String depart;
  late String arrivee;
  late String date = '';
  late String heure = '';
  late String nbPlaces;
  late String prix;
  late String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Proposer un trajet'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Départ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le lieu de départ.';
                  }
                  return null;
                },
                onSaved: (value) {
                  depart = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Arrivée'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le lieu d\'arrivée.';
                  }
                  return null;
                },
                onSaved: (value) {
                  arrivee = value!;
                },
              ),
              // Add other text form fields for additional trip details
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la date.';
                  }
                  return null;
                },
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      date = selectedDate
                          .toString(); // You might want to format the date here
                    });
                  }
                },
                controller: TextEditingController(
                  text: date, // To display the selected date
                ),
                readOnly: true, // Prevents manual editing of the date field
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Heure'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir l\'heure.';
                  }
                  return null;
                },
                onTap: () async {
                  final TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      heure = selectedTime
                          .format(context); // Format the selected time
                    });
                  }
                },
                controller: TextEditingController(
                    text: heure), // To display the selected time
                readOnly: true, // Prevents manual editing of the time field
                onSaved: (value) {
                  // No need to save here as the value will be updated in onTap
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de places'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nombre de places.';
                  }
                  return null;
                },
                onSaved: (value) {
                  nbPlaces = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prix'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le prix.';
                  }
                  return null;
                },
                onSaved: (value) {
                  prix = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Commentaire'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le commentaire  souhaité';
                  }
                  return null;
                },
                onSaved: (value) {
                  message = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _trajetService.addTrajet(
                      depart: depart,
                      arrivee: arrivee,
                      date: date,
                      heure: heure,
                      nbPlaces: nbPlaces,
                      prix: prix,
                      message: message,
                    );
                    Navigator.pop(context); // Close the dialog
                  }
                },
                child: Text('Proposer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
