import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
        ),
        body: MessagesWidget(),
      ),
    );
  }
}

class MessagesWidget extends StatefulWidget {
  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/messages'));

      if (response.statusCode == 200) {
        final List<dynamic> fetchedMessages = json.decode(response.body);
        setState(() {
          messages = fetchedMessages;
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      // Hata yönetimi
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          title: Text(message['content']),
        );
      },
    );
  }
}
