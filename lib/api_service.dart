import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quiz.dart';

class ApiService {
  final String _baseUrl = 'https://api.jsonserve.com/Uw5CrX';

  Future<List<Question>> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      // print('Response Status Code: ${response.statusCode}');
      // print('Response Headers: ${response.headers}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> questionsJson = jsonResponse['questions'];
        return questionsJson.map((json) => Question.fromJson(json)).toList();
      } else {
        print('Failed to load questions: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow; // Rethrow the exception after logging
    }
  }
}