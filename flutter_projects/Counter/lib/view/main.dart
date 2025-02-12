import 'package:flutter/material.dart';
import 'package:counter/controller/counter_controller.dart';

void main() {
  runApp(Counter());
}

/// Root of the application.s,a
class Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterView(), // Set the home screen to CounterView.
    );
  }
}

/// represent the View in the MVC pattern.
/// Handles user interaction and displays the counter.
class CounterView extends StatefulWidget {
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller =
      CounterController(); // Controller instance.

  /// Updates the UI when the counter value changes.
  void _updateUI() {
    setState(() {}); // Rebuilds the UI.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple MVC Counter"), // App title.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center-align widgets.
          children: [
            Text(
              "Counter Value:",
              style: TextStyle(fontSize: 20), // Styling for the label.
            ),
            Text(
              "${_controller.counter}", // Display the current counter value.
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold), // Styling for the value.
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Align buttons in a row.
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller
                        .increment(); // Increment the counter via Controller.
                    _updateUI(); // Update the UI to reflect changes.
                  },
                  child: Text("Increment"),
                ),
                SizedBox(width: 16), // Add space between buttons.
                ElevatedButton(
                  onPressed: () {
                    _controller
                        .decrement(); // Decrement the counter via Controller.
                    _updateUI(); // Update the UI to reflect changes.
                  },
                  child: Text("Decrement"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
