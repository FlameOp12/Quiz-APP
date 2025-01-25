import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'quiz.dart';
import 'home_screen.dart'; // Import HomeScreen

class ResultScreen extends StatelessWidget {
  final int score;
  final List<Question> questions;
  final List<int?> selectedOptions;

  ResultScreen({
    required this.score,
    required this.questions,
    required this.selectedOptions,
  });

  String getReward(int score) {
    if (score >= 90) {
      return 'Gold Medal';
    } else if (score >= 70) {
      return 'Silver Medal';
    } else if (score >= 50) {
      return 'Bronze Medal';
    } else {
      return 'Keep Practicing!';
    }
  }

  String getLottieAsset(int score) {
    if (score >= 90) {
      return 'assets/gold_medal.json';
    } else if (score >= 70) {
      return 'assets/silver_medal.json';
    } else if (score >= 50) {
      return 'assets/bronze_medal.json';
    } else {
      return 'assets/motivation.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final reward = getReward(score);
    final lottieAsset = getLottieAsset(score);
    final totalQuestions = questions.length;
    final percentageScore = (score / totalQuestions * 10).toStringAsFixed(1);
    final totalscore = totalQuestions * 10;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF158e8c), Color(0xFF2b275d)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Lottie.asset(
                      lottieAsset,
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Total Score: $score/$totalscore',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Percentage: $percentageScore%',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Reward: $reward',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              ...questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                final selectedOptionIndex = selectedOptions[index];
                final correctOptionIndex =
                    question.options.indexWhere((option) => option.isCorrect);
                return Container(
                  width: double.infinity, // Ensures full width
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4.0,
                    color: Colors.white, // Set background color to white
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${index + 1}: ${question.description}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Selected Option: ${selectedOptionIndex != null ? question.options[selectedOptionIndex].description : 'Not Answered'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedOptionIndex != null &&
                                      correctOptionIndex != -1 &&
                                      selectedOptionIndex == correctOptionIndex
                                  ? Colors.green
                                  : selectedOptionIndex != null && correctOptionIndex != -1
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                          ),
                          if (correctOptionIndex != -1)
                            Text(
                              'Correct Option: ${question.options[correctOptionIndex].description}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Colors.transparent, // Make the button transparent
                  shadowColor: Colors.transparent, // Remove shadow
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue.withOpacity(0.5); // Change on press
                      }
                      return Colors.transparent; // Default color
                    },
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF158e8c), Color(0xFF2b275d)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Restart Quiz',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}