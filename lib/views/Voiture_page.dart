import 'package:flutter/material.dart';

class VoiturePage extends StatefulWidget {
  @override
  _VoiturePageState createState() => _VoiturePageState();
}

class _VoiturePageState extends State<VoiturePage> {
  List<Map<String, dynamic>> cars = [
    {
      'marque': 'Renault',
      'modele': 'Clio',
      'annee': 2018,
      'couleur': 'Rouge',
    },
    {
      'marque': 'Peugeot',
      'modele': '308',
      'annee': 2020,
      'couleur': 'Gris',
    },
    {
      'marque': 'Volkswagen',
      'modele': 'Golf',
      'annee': 2022,
      'couleur': 'Blanc',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Voitures'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                // Filtrer la liste des voitures en fonction de la recherche
              },
              decoration: InputDecoration(
                hintText: 'Rechercher une voiture',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text(
                      '${cars[index]['marque']} ${cars[index]['modele']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Année : ${cars[index]['annee']} - Couleur : ${cars[index]['couleur']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Ouvrir le formulaire de modification de la voiture
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Supprimer la voiture de la liste
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.drive_eta),
                          onPressed: () {
                            // Utiliser cette voiture pour une course
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ouvrir le formulaire d'ajout d'une nouvelle voiture
        },
        child: Icon(Icons.add),
      ),
    );
  }
}