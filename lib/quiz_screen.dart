import 'package:flutter/material.dart';
import 'dart:async';
import 'api_service.dart';
import 'quiz.dart';
import 'result_screen.dart'; // Import ResultScreen
import 'package:lottie/lottie.dart';


class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<int?> _selectedOptions = [];
  List<bool> _markedForReview = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Timer? _timer;
  int _remainingTime = 600; // 10 minutes in seconds
  bool _showAnimation = false;
DateTime _questionStartTime = DateTime.now(); // Track question start time

  


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
        _markedForReview = List.filled(questions.length, false);
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
      _questionStartTime = DateTime.now(); // Reset timer for new question
    });
  } else {
    // Finish action
    _finishQuiz();
  }
}


void _previousQuestion() {
  if (_currentQuestionIndex > 0) {
    setState(() {
      _currentQuestionIndex--;
      _questionStartTime = DateTime.now(); // Reset timer for previous question
    });
  }
}


void _checkAnswer(int index) {
  setState(() {
    _selectedOptions[_currentQuestionIndex] = index;

    // Check if answered within 30 seconds
    if (DateTime.now().difference(_questionStartTime).inSeconds <= 30) {
      _showAnimation = true;
      
      // Hide animation after 2 seconds
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _showAnimation = false;
        });
      });
    }

    if (_questions[_currentQuestionIndex].options[index].isCorrect) {
      _score += 10;
    }
  });
}


  void _toggleMarkForReview() {
    setState(() {
      _markedForReview[_currentQuestionIndex] = !_markedForReview[_currentQuestionIndex];
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
      body: Stack(
  children: [
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color.fromARGB(255, 175, 177, 179), const Color.fromARGB(255, 163, 167, 170)],
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
                          disabledBackgroundColor: Colors.blue,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _markedForReview[_currentQuestionIndex] ? Icons.flag : Icons.flag_outlined,
                                    color: _markedForReview[_currentQuestionIndex] ? Colors.yellow : Colors.grey,
                                  ),
                                  onPressed: _toggleMarkForReview,
                                ),
                              ],
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
                                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
    style: TextStyle(fontSize: 20, color: const Color.fromARGB(240, 255, 255, 255), fontWeight: FontWeight.bold),
  ),
),

                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Attempted: ${_selectedOptions.where((option) => option != null).length}',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  'Not Attempted: ${_selectedOptions.where((option) => option == null).length}',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  'Marked for Review: ${_markedForReview.where((mark) => mark).length}',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _questions.length,
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _selectedOptions[index] != null
                                        ? Colors.green
                                        : _markedForReview[index]
                                            ? Colors.yellow
                                            : Colors.grey,
                                  ),
                                  child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              Spacer(),
            ],
          ),
        ),
      ),
    ),

    // Lottie Animation Overlay
    if (_showAnimation)
      Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.3), // Slight dark overlay
          child: Center(
            child: Lottie.asset(
              'assets/celebration.json',  // Replace with your Lottie file
              width: 200,
              height: 200,
              repeat: false,
            ),
          ),
        ),
      ),
  ],
),

    );
  }
}