import 'package:drivetogether/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(DriveTogetherApp());
}

class DriveTogetherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveTogether',
      // Assurez-vous d'ajouter la nouvelle page à vos routes si vous utilisez une gestion de route nommée
      routes: {
        '/': (context) => HomePage(), // Votre page d'accueil
        '/proposer_trajet': (context) =>
            ProposerTrajetPage(), // La nouvelle page de proposition de trajet
        // Ajoutez d'autres routes ici
      },
      // Ajoutez d'autres propriétés de MaterialApp si nécessaire
    );
  }
}

class ProposerTrajetPage extends StatefulWidget {
  @override
  _ProposerTrajetPageState createState() => _ProposerTrajetPageState();
}

class _ProposerTrajetPageState extends State<ProposerTrajetPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _allerRetour = false;
  double _cotisation = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proposer Trajet'),
      ),
      body: FormBuilder(
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
              min: 1,
              max: 30,
              divisions: 29,
              value: _cotisation,
              onChanged: (double value) {
                setState(() {
                  _cotisation = value;
                });
              },
            ),

            // ... autres widgets de formulaire
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  // Ici, vous pouvez ajouter la logique pour envoyer les données du formulaire à votre backend
                  print(_formKey.currentState!.value);
                }
              },
              child: Text('Proposer'),
            ),

            ElevatedButton(
              onPressed: () {
                // Votre logique ici
              },
              child: Text('Cliquez ici'),
            ),

            ElevatedButton(
              onPressed: () {
                // Ajouter logique pour voir itinéraire
              },
              child: Text('Voir itinéraire'),
            ),
            Text('Voiture du trajet : Aston Martin Vanquis'),
          ],
        ),
      ),
    );
  }
}
