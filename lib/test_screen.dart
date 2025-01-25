import 'package:flutter/material.dart';
import 'dart:async';
import 'api_service.dart';
import 'quiz.dart';
import 'result_screen.dart'; // Import ResultScreen

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<int?> _selectedOptions = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Timer? _timer;
  int _remainingTime = 600; // 10 minutes in seconds

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final questions = await ApiService().fetchQuestions();
      setState(() {
        _questions = questions;
        _selectedOptions = List.filled(questions.length, null);
        _isLoading = false;
        _startTimer();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: _score,
          questions: _questions,
          selectedOptions: _selectedOptions,
        ),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _checkAnswer(int index) {
    setState(() {
      _selectedOptions[_currentQuestionIndex] = index;
      if (_questions[_currentQuestionIndex].options[index].isCorrect) {
        _score += 10;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF158e8c), // Color 1
                Color(0xFF2b275d),],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
        title: Text(
          'Quiz App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 245, 246, 248), const Color.fromARGB(255, 207, 212, 216)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else if (_errorMessage.isNotEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'An error occurred:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchQuestions,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF2196F3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 8,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shadowColor: Colors.blue.withAlpha(120),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_questions.isEmpty)
                  Center(child: Text('No questions available.', style: TextStyle(fontSize: 18, color: Colors.white)))
                else
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _questions[_currentQuestionIndex].description,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          SizedBox(height: 16),
                          ...List.generate(
                            _questions[_currentQuestionIndex].options.length,
                            (index) => RadioListTile<int>(
                              title: Text(
                                _questions[_currentQuestionIndex].options[index].description,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              value: index,
                              groupValue: _selectedOptions[_currentQuestionIndex],
                              onChanged: (value) => _checkAnswer(value!),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2b275d),
                                  disabledBackgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  elevation: 8,
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shadowColor: Colors.blue.withAlpha(120),
                                ),
                                child: Text(
                                  'Previous',
                                  style: TextStyle(fontSize: 20,color: const Color.fromARGB(249, 255, 255, 255), fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _nextQuestion,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF158e8c),
                                  disabledBackgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  elevation: 8,
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shadowColor: Colors.blue.withAlpha(120),
                                ),
                                child: Text(
                                  _currentQuestionIndex < _questions.length - 1 ? 'Next' : 'Finish',
                                  style: TextStyle(fontSize: 20,color: const Color.fromARGB(253, 255, 255, 255), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}