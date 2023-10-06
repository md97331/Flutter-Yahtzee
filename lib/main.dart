import 'package:flutter/material.dart';
import 'views/yahtzee.dart';

void main() {
  runApp(MaterialApp(
    home: const Yahtzee(),
    theme: ThemeData(primarySwatch: Colors.orange),
  ));
}
