import 'package:collection/collection.dart';
import 'dart:math';

class Dice {
  final List<int?> _values;
  final List<bool> _held;
  int _rolls = 0; // Add a rolls counter
  final List<List<int>> _rollHistory = []; // Store roll history

  Dice(int numDice)
      : _values = List<int?>.filled(numDice, null),
        _held = List<bool>.filled(numDice, false);

  List<int> get values => List<int>.unmodifiable(_values.whereNotNull());

  int? operator [](int index) => _values[index];

  bool isHeld(int index) => _held[index];

  int get rolls => _rolls; // Getter for rolls

  List<List<int>> get rollHistory => _rollHistory; // Getter for roll history

  void clear() {
    for (var i = 0; i < _values.length; i++) {
      _values[i] = null;
      _held[i] = false;
    }
    _rolls = 0; // Reset rolls counter
    _rollHistory.clear(); // Clear roll history
  }

  void roll() {
    if (_rolls < 3) {
      List<int> currentRoll = [];
      for (var i = 0; i < _values.length; i++) {
        if (!_held[i]) {
          int rollResult = Random().nextInt(6) + 1;
          _values[i] = rollResult;
          currentRoll.add(rollResult); // Store the roll result
        }
      }
      _rollHistory.add(currentRoll); // Store the current roll in history
      _rolls++;
    }
  }

  void toggleHold(int index) {
    _held[index] = !_held[index];
  }
}
