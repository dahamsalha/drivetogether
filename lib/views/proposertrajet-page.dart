import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ProposerTrajetPage extends StatefulWidget {
  @override
  _ProposerTrajetPageState createState() => _ProposerTrajetPageState();
}

class _ProposerTrajetPageState extends State<ProposerTrajetPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _allerRetour = false;
  double _cotisation = 0;

  final CollectionReference trajetCollection =
      FirebaseFirestore.instance.collection('trajet');
  Future<void> _enregistrerTrajet(data) async {
    try {
      Map<String, dynamic> trajetData = {
        'aller_retour': data['aller_retour'] as bool,
        'cotisation': double.parse(data['cotisation'].toString()),
        'date': data['date'] as String,
        'destination': data['destination'] as String,
        'heure': data['heure'] as String,
        'place de disponible': int.parse(data['nb_places'].toString()),
        'point_depart': data['point_depart'] as String,
        'type_trajet': data['type_trajet'] as String,
      };
      print('data');
      print(trajetData);
      await trajetCollection.add(trajetData);

    
      print('test');
    } catch (e) {
      print("Erreur Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Une erreur s\'est produite lors de l\'enregistrement du trajet: $e'),
        ),
      );
      print('Erreur lors de l\'enregistrement du trajet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proposer trajet"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderTextField(
                  name: 'point_depart',
                  decoration: InputDecoration(
                    labelText: 'Sélectionnez un point de départ',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Ce champ est obligatoire'),
                ),
                SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'destination',
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Ce champ est obligatoire'),
                ),
                SizedBox(height: 16),
                FormBuilderChoiceChip<String>(
                  name: 'type_trajet',
                  decoration: InputDecoration(
                    labelText: 'Type de trajet',
                  ),
                  options: const [
                    FormBuilderChipOption(
                      value: 'regulier',
                      child: Text('Trajet régulier'),
                    ),
                    FormBuilderChipOption(
                      value: 'simple',
                      child: Text('Trajet Simple'),
                    ),
                  ],
                  validator: FormBuilderValidators.required(
                      errorText: 'Ce champ est obligatoire'),
                ),
                SizedBox(height: 16),
                FormBuilderDateTimePicker(
                  name: 'date',
                  decoration: InputDecoration(
                    labelText: 'Sélectionnez la date',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Ce champ est obligatoire'),
                ),
                SizedBox(height: 16),
                FormBuilderDateTimePicker(
                  name: 'heure',
                  decoration: InputDecoration(
                    labelText: 'Sélectionnez l\'heure',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Ce champ est obligatoire'),
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'nb_places',
                  decoration: InputDecoration(
                    labelText: 'Nombre de places',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.required(
                      errorText: 'Ce champ est obligatoire'),
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final formData = _formKey.currentState?.value ?? {};
                    formData['cotisation'] = _cotisation;
                    formData['aller_retour'] = _allerRetour;
                    if (_formKey.currentState?.validate() ?? false) {
                      await _enregistrerTrajet(formData);
                      print(formData);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Veuillez remplir tous les champs obligatoires'),
                        ),
                      );
                    }
                  },
                  child: Text('Proposer'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Logique d'affichage de l'itinéraire
                  },
                  child: Text('Voir itinéraire'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
