import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'quiz_screen.dart'; // Import the QuizScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/quiz': (context) => QuizScreen(), // Define the '/quiz' route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
