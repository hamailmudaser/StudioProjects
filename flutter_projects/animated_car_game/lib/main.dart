import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(CarGame()); //apprun krny k lie use hota hai

class CarGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // car ki initial postion k lie
  double _carXPosition = 0;

  // Obstacle position
  double _obstacleXPosition = 0;
  double _obstacleYPosition = -1; // Starts off-screen

  // Game state
  bool _isGameOver = false;
  int _score = 0;

  Timer? _gameLoop;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    // Reset game variables
    setState(() {
      _carXPosition = 0;
      _obstacleXPosition = Random().nextInt(3) - 1.0; // Random -1, 0, or 1
      _obstacleYPosition = -1;
      _isGameOver = false;
      _score = 0;
    });

    // Start game loop
    _gameLoop = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_isGameOver) {
          timer.cancel();
        } else {
          // Move obstacle down
          _obstacleYPosition += 0.05;

          // Check for collision
          if (_obstacleYPosition >= 0.8 &&
              (_carXPosition - _obstacleXPosition).abs() < 0.2) {
            _isGameOver = true;
            timer.cancel();
            _showGameOverDialog();
          }

          // Reset obstacle when it moves off-screen
          if (_obstacleYPosition > 1) {
            _obstacleYPosition = -1;
            _obstacleXPosition =
                Random().nextInt(3) - 1.0; // New random position
            _score += 1; // Increase score
          }
        }
      });
    });
  }

  void _moveCarLeft() {
    setState(() {
      if (_carXPosition > -1) _carXPosition -= 1;
    });
  }

  void _moveCarRight() {
    setState(() {
      if (_carXPosition < 1) _carXPosition += 1;
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your Score: $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Stack(
        children: [
          // Road
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                20,
                (index) => Container(
                  width: 5,
                  height: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Obstacle
          AnimatedPositioned(
            duration: Duration(milliseconds: 0),
            top: MediaQuery.of(context).size.height * _obstacleYPosition,
            left: MediaQuery.of(context).size.width / 2 +
                (_obstacleXPosition * 100) -
                25,
            child: Container(
              width: 50,
              height: 100,
              color: Colors.blue,
            ),
          ),
          // Car
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 +
                (_carXPosition * 100) -
                25,
            child: Container(
              width: 50,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Score
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'Score: $_score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Left Button
          Positioned(
            bottom: 20,
            left: 50,
            child: ElevatedButton(
              onPressed: _moveCarLeft,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
              child: Icon(Icons.arrow_left),
            ),
          ),
          // Right Button
          Positioned(
            bottom: 20,
            right: 50,
            child: ElevatedButton(
              onPressed: _moveCarRight,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
              child: Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }
}
