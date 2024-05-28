import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  String? _selectedLanguage = 'Français'; // Replace with your default language
  bool _notificationsEnabled = true; // Replace with your default value
  String? _selectedVehicleType = 'Voiture'; // Replace with your default value
  bool _airConditioningEnabled = true; // Replace with your default value
  bool _petsAllowed = false; // Replace with your default value
  bool _smokingAllowed = false; // Replace with your default value
  String? _genderPreference = 'Mixte'; // Replace with your default value
  bool _musicAllowed = true; // Replace with your default value

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Langue'),
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            items: ['Français', 'Anglais','Arabe'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
            },
          ),
        ),
        SwitchListTile(
          title: Text('Notifications'),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        ListTile(
          title: Text('Type de véhicule'),
          trailing: DropdownButton<String>(
            value: _selectedVehicleType,
            items: ['Voiture', 'SUV', 'Van'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedVehicleType = newValue!;
              });
            },
          ),
        ),
        SwitchListTile(
          title: Text('Climatisation'),
          value: _airConditioningEnabled,
          onChanged: (bool value) {
            setState(() {
              _airConditioningEnabled = value;
            });
          },
        ),
        SwitchListTile(
          title: Text('Animaux autorisés'),
          value: _petsAllowed,
          onChanged: (bool value) {
            setState(() {
              _petsAllowed = value;
            });
          },
        ),
        SwitchListTile(
          title: Text('Autoriser le tabac'),
          value: _smokingAllowed,
          onChanged: (bool value) {
            setState(() {
              _smokingAllowed = value;
            });
          },
        ),
        ListTile(
          title: Text('Préférence de genre'),
          trailing: DropdownButton<String>(
            value: _genderPreference,
            items: ['Homme', 'Femme', 'Mixte'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _genderPreference = newValue!;
              });
            },
          ),
        ),
        SwitchListTile(
          title: Text('Autoriser la musique'),
          value: _musicAllowed,
          onChanged: (bool value) {
            setState(() {
              _musicAllowed = value;
            });
          },
        ),
      ],
    );
  }
}
