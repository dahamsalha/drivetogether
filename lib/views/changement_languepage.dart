import 'package:drivetogether/main.dart';
import 'package:flutter/material.dart';

class LanguageChangePage extends StatefulWidget {
  @override
  _LanguageChangePageState createState() => _LanguageChangePageState();
}

class _LanguageChangePageState extends State<LanguageChangePage> {
  Locale? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Changer de langue'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Français'),
            trailing: Radio<Locale>(
              value: Locale('fr', 'FR'),
              groupValue: _selectedLocale,
              onChanged: (Locale? value) {
                setState(() {
                  _selectedLocale = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('English'),
            trailing: Radio<Locale>(
              value: Locale('en', 'US'),
              groupValue: _selectedLocale,
              onChanged: (Locale? value) {
                setState(() {
                  _selectedLocale = value;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Changez la langue de l'application
          MyApp.setLocale(context, _selectedLocale!);
        },
        child: Icon(Icons.done),
      ),
    );
  }
}