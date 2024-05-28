import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivetogether/controllers/trajetService.dart';
import 'package:drivetogether/views/background_container.dart';
import 'package:drivetogether/views/itineraire_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class trajetScreen extends StatefulWidget {
  trajetScreen({super.key});

  @override
  _trajetScreenState createState() => _trajetScreenState();
}

class trajetModele {
  final String depart;
  final String arrivee;
  final String date;
  final String heure;
  final String nbPlaces;
  final String prix;
  final String message;
  final String driver_id;

  trajetModele({
    required this.depart,
    required this.arrivee,
    required this.date,
    required this.heure,
    required this.nbPlaces,
    required this.prix,
    required this.message,
    required this.driver_id,
  });
}

class _trajetScreenState extends State<trajetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final CollectionReference trajetCollection =
      FirebaseFirestore.instance.collection('trajet');

  Future<void> _enregistrerTrajet(Map<String, dynamic> data) async {
    try {
      bool allerRetour = data['aller_retour'] ?? false;
      double cotisation = double.tryParse(data['cotisation'].toString()) ?? 0.0;
      String date = data['date']?.toString() ?? '';
      String destination = data['destination']?.toString() ?? '';
      String heure = data['heure']?.toString() ?? '';
      String pointDepart = data['point_depart']?.toString() ?? '';
      String typeTrajet = data['type_trajet']?.toString() ?? '';

      Map<String, dynamic> trajetData = {
        'aller_retour': allerRetour,
        'cotisation': cotisation,
        'date': date,
        'destination': destination,
        'heure': heure,
        'point_depart': pointDepart,
        'type_trajet': typeTrajet,
      };

      print('Trajet Data: $trajetData');
      await trajetCollection.add(trajetData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trajet proposé avec succès'),
        ),
      );
    } catch (e) {
      print("Erreur Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Une erreur s\'est produite lors de l\'enregistrement du trajet: $e'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  bool _allerRetour = false;
  double _cotisation = 0;

  final trajetModele _trajet = trajetModele(
    depart: '',
    arrivee: '',
    date: '',
    heure: '',
    nbPlaces: '',
    prix: '',
    message: '',
    driver_id: '',
  );

  final TrajetService _trajetService = TrajetService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trajet"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Trajet"),
            Tab(text: "proposer"),
          ],
        ),
      ),
      body: BackgroundContainer( // Utilisez le widget personnalisé ici
        child:TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Départ: ${_trajet.depart}'),
                Text('Arrivée: ${_trajet.arrivee}'),
                Text('Date: ${_trajet.date}'),
                Text('Heure: ${_trajet.heure}'),
                Text('Nombre de place: ${_trajet.nbPlaces}'),
                Text('Prix: ${_trajet.prix}'),
                Text('Message: ${_trajet.message}'),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'point_depart',
                      decoration: InputDecoration(
                        labelText: 'Sélectionnez un point de départ',
                      ),
                    ),
                    FormBuilderTextField(
                      name: 'destination',
                      decoration: InputDecoration(
                        labelText: 'Destination',
                      ),
                    ),
                    FormBuilderChoiceChip<String>(
                      name: 'type_trajet',
                      decoration: InputDecoration(
                        labelText: 'Type de trajet',
                      ),
                      options: const [
                        FormBuilderChipOption(
                            value: 'regulier', child: Text('Trajet régulier')),
                        FormBuilderChipOption(
                            value: 'simple', child: Text('Trajet Simple')),
                      ],
                    ),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      decoration: InputDecoration(
                        labelText: 'Sélectionnez la date',
                      ),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'heure',
                      decoration: InputDecoration(
                        labelText: 'Sélectionnez lheure',
                      ),
                    ),
                    FormBuilderCheckbox(
                      name: 'aller_retour',
                      initialValue: false,
                      onChanged: (bool? value) {
                        setState(() {
                          _allerRetour = value!;
                        });
                      },
                      title: Text('Aller retour'),
                    ),
                    Text('Cotisation : ${_cotisation.toStringAsFixed(2)}DT'),
                    Slider(
                      min: 0,
                      max: 30,
                      divisions: 29,
                      value: _cotisation,
                      onChanged: (double value) {
                        setState(() {
                          _cotisation = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await _enregistrerTrajet(
                              _formKey.currentState!.value);
                          print(_formKey.currentState!.value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Trajet enregistré avec succès')),
                          );
                        }
                      },
                      child: Text('Proposer'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItineraireScreen(
                              depart: '',
                              arrivee: '',
                              /* provide the departure location */
                              /* provide the arrival location */
                            ),
                          ),
                        );
                      },
                      child: Text('Voir itinéraire'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
