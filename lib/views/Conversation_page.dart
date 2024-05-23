import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  List<String> conversations = ['Bonjour, comment ça va ?', 'Il fait beau aujourd\'hui.', 'J\'aime drive together.','je le prefere aussi']; // Replace with your own conversations

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.message),
          title: Text('Conversation ${index + 1}'),
          subtitle: Text(conversations[index]),
        );
      },
    );
  }
}
