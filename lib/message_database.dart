import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> getMessages() async {
  final response = await http.get(Uri.parse('http://localhost:3000/messages'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return jsonData;
  } else {
    throw Exception('Failed to load messages');
  }
}
