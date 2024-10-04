import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int maxLives = 6;
  int lives = maxLives;
  String word = '';
  Set<String> guessedLetters = {};
  List<String> hangmanStages = [
    'assets/hangman/hangman_0.png', // No body
    'assets/hangman/hangman_1.png', // Head
    'assets/hangman/hangman_2.png', // Body
    'assets/hangman/hangman_3.png', // Left arm
    'assets/hangman/hangman_4.png', // Right arm
    'assets/hangman/hangman_5.png', // Left leg
    'assets/hangman/hangman_6.png', // Right leg
  ];

  @override
  void initState() {
    super.initState();
    word = generateRandomWord().toUpperCase();
  }

  String generateRandomWord() {
    return WordPair.random().asPascalCase; // Generates a random word
  }

  void guessLetter(String letter) {
    setState(() {
      guessedLetters.add(letter);
      if (!word.contains(letter)) {
        lives--;
      }
    });
  }

  bool get hasWon => word.split('').every((letter) => guessedLetters.contains(letter));
  bool get hasLost => lives <= 0;

  void revealLetter() {
    // Reveal a random letter in the word as a hint
    final remainingLetters = word.split('').where((letter) => !guessedLetters.contains(letter)).toList();
    if (remainingLetters.isNotEmpty) {
      final letterToReveal = (remainingLetters..shuffle()).first;
      guessedLetters.add(letterToReveal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: revealLetter,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(hangmanStages[maxLives - lives]),
            SizedBox(height: 20),
            Text(
              'Lives: $lives',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              word.split('').map((letter) => guessedLetters.contains(letter) ? letter : '_').join(' '),
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: List.generate(26, (index) {
                String letter = String.fromCharCode(index + 65); // A-Z
                return ElevatedButton(
                  onPressed: guessedLetters.contains(letter) || hasWon || hasLost ? null : () => guessLetter(letter),
                  child: Text(letter),
                );
              }),
            ),
            if (hasWon)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Congratulations! You won!', style: TextStyle(fontSize: 24, color: Colors.green)),
              ),
            if (hasLost)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('You lost! The word was $word.', style: TextStyle(fontSize: 24, color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
