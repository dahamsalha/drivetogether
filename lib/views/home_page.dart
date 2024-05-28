import 'package:drivetogether/views/background_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _signUpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
         Stack(
        fit: StackFit.expand, // Make the stack fill the entire screen
        children: [
          
          // Background image
          Image.asset(
      
            'assets/images/drivetogether1.jpg',

           
            width: 90, // Utilise la largeur de l'écran
  height: 90,
          ), // Hauteur fixée à 150 pixels
          // Content below the background image
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Login to continue:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Set text color to white
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/login'); // Navigate to the login page
                      },
                      child: Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      
      )
    );
  }
}
