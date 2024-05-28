import 'package:drivetogether/views/background_container.dart';
import 'package:flutter/material.dart';

class AvisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avis'),
      ),
     body: BackgroundContainer(
        child:  ListView(
        children: [
          ListTile(
            title: Text('Avis du conducteur sur le passager'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/avis-conducteur');
            },
          ),
          ListTile(
            title: Text('Avis du passager sur le conducteur'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/avis-passager');
            },
          ),
        ],
      ),
     ),
    );
  }
}
