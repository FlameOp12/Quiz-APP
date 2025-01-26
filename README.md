# Quiz App

## Overview

The Quiz App is a modern and interactive mobile application designed to test and enhance users' knowledge across various topics. The app provides a seamless and engaging quiz-taking experience with features such as a countdown timer, question tracking, and the ability to mark questions for review.

## Features

### 1. Modern Design
- **Gradient Backgrounds**: The app uses gradient backgrounds to create a visually appealing and modern look.
- **Customized App Bar**: A gradient-colored app bar with a timer to keep track of the remaining time.

### 2. Interactive Quiz
- **Multiple Choice Questions**: Each question presents multiple-choice options for the user to select from.
- **Next and Previous Buttons**: Users can navigate between questions using the "Next" and "Previous" buttons.
- **Mark for Review**: Users can mark questions for review and easily track which questions they have marked.

### 3. Question Tracking
- **Status Card**: A card at the bottom of the screen shows the number of attempted, not attempted, and marked for review questions.
- **Question Icons**: Icons representing each question are displayed in a row, with different colors to indicate the status:
  - **Green**: Attempted questions
  - **Grey**: Not attempted questions
  - **Yellow**: Marked for review questions

### 4. Timer
- **Countdown Timer**: A timer in the app bar counts down from 10 minutes, ensuring users complete the quiz within the given time.

### 5. Error Handling
- **Loading Indicator**: A loading indicator is displayed while fetching questions from the API.
- **Error Messages**: If an error occurs during the fetching process, an error message is shown with a retry button.

### 6. Results
- **Result Screen**: After completing the quiz, users are directed to a result screen that displays their total score and detailed results for each question.
- **Detailed Results**: For each question, the result screen shows the selected option, the correct option, and additional information like detailed solutions, reading materials, and practice materials.

## Installation

### Prerequisites
- Flutter SDK installed on your machine.
- A code editor (e.g., Visual Studio Code, Android Studio).
- A device or emulator to run the app.

### Steps
1. **Clone the Repository**
   ```sh
   git clone https://github.com/yourusername/quiz_app.git
   cd quiz_app
2. **GET DEPENDENCIES**
   ```sh
   flutter clean
   flutter pub get
3. **RUN FLUTTER**
   ```sh
   flutter run -d chrome --web-browser-flag "--disable-web-security"
## FLUTTER SETUP (VS CODE UBUNTU)
### Steps
1. **Install FLUTTER and DART extension is vs code **
   ```sh
2. **ON TERMINAL**
   ```sh
   sudo snap install flutter --classic
3. **IN PROJECT DIRECTORY**
   ```sh
   flutter doctor
## VIDEO WALKTHROUGH AND SCREENSHOTS WITH SETUP:  https://drive.google.com/drive/folders/1ccnf2EPy-VpXSDr4E961WlOtztTMCZ-J?usp=sharing
