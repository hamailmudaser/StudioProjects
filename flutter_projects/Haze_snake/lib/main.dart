import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 2; // Increase progress by 2% each step
      });
      if (progress >= 100) {
        timer.cancel();
        _navigateToGameScreen();
      }
    });
  }

  void _navigateToGameScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Snake Logo
          const Center(
            child: Text(
              "Snake",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Loading Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade300,
              color: Colors.green,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading... ${progress.toInt()}%",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int rows = 20;
  static const int columns = 20;
  Duration gameSpeed = const Duration(milliseconds: 200);

  List<int> snake = [
    (rows ~/ 2) * columns + (columns ~/ 2),
  ];

  String direction = 'right';
  int food = Random().nextInt(rows * columns);
  Timer? timer;
  int score = 0;

  void startGame() {
    timer?.cancel();
    snake = [(rows ~/ 2) * columns + (columns ~/ 2)];
    direction = 'right';
    food = Random().nextInt(rows * columns);
    score = 0;
    gameSpeed = const Duration(milliseconds: 200);
    timer = Timer.periodic(gameSpeed, (timer) => updateSnake());
  }

  void updateSnake() {
    setState(() {
      int head = snake.last;
      int newHead;
      switch (direction) {
        case 'up':
          newHead = head - columns;
          break;
        case 'down':
          newHead = head + columns;
          break;
        case 'left':
          newHead = head - 1;
          break;
        case 'right':
          newHead = head + 1;
          break;
        default:
          return;
      }

      if (newHead < 0 ||
          newHead >= rows * columns ||
          (direction == 'left' && head % columns == 0) ||
          (direction == 'right' && newHead % columns == 0) ||
          snake.contains(newHead)) {
        timer?.cancel();
        showGameOverDialog();
        return;
      }

      snake.add(newHead);

      if (newHead == food) {
        score++;
        food = Random().nextInt(rows * columns);

        if (gameSpeed.inMilliseconds > 50) {
          gameSpeed = Duration(milliseconds: gameSpeed.inMilliseconds - 10);
          timer?.cancel();
          timer = Timer.periodic(gameSpeed, (timer) => updateSnake());
        }
      } else {
        snake.removeAt(0);
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void changeDirection(String newDirection) {
    if ((direction == 'up' && newDirection == 'down') ||
        (direction == 'down' && newDirection == 'up') ||
        (direction == 'left' && newDirection == 'right') ||
        (direction == 'right' && newDirection == 'left')) {
      return;
    }
    direction = newDirection;
  }

  Widget buildGrid() {
    return GridView.builder(
      itemCount: rows * columns,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) {
        if (snake.contains(index)) {
          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        } else if (index == food) {
          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8),
            Text('Snake Game'),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  changeDirection('down');
                } else if (details.delta.dy < 0) {
                  changeDirection('up');
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  changeDirection('right');
                } else if (details.delta.dx < 0) {
                  changeDirection('left');
                }
              },
              child: buildGrid(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Score: $score',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => changeDirection('up'),
                      child: const Icon(Icons.arrow_upward),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => changeDirection('left'),
                      child: const Icon(Icons.arrow_back),
                    ),
                    ElevatedButton(
                      onPressed: startGame,
                      child: const Text('Start / Reset'),
                    ),
                    ElevatedButton(
                      onPressed: () => changeDirection('right'),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => changeDirection('down'),
                      child: const Icon(Icons.arrow_downward),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
