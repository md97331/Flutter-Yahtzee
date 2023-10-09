import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';

class DiceWindow extends StatefulWidget {
  final Dice dice; // Dice (window)
  final bool categoryPicked; //know if category has been picked

  const DiceWindow({Key? key, required this.dice, required this.categoryPicked})
      : super(key: key);

  @override
  DiceWindowState createState() => DiceWindowState();
}

class DiceWindowState extends State<DiceWindow> {
  @override
  Widget build(BuildContext context) {
    //button (roll dice or no more rolls)
    String buttonText = (widget.dice.rolls < 3 || widget.categoryPicked)
        ? "Roll Dice"
        : "No More Rolls";

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 5; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DiceSquare(index: i, dice: widget.dice),
                ),
              ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            textStyle: const TextStyle(fontSize: 16),
          ),
          onPressed:
          // If the game has ended, disable the button
          (widget.dice.rolls < 3) ? () => rollDice() : null,
          child: Text(buttonText),
        ),
      ],
    );
  }

  void rollDice() {
    setState(() {
      widget.dice.roll();
    });
  }
}

class DiceSquare extends StatefulWidget {
  final int index; //index of dice
  final Dice dice; //dice

  const DiceSquare({Key? key, required this.index, required this.dice})
      : super(key: key);

  @override
  DiceSquareState createState() => DiceSquareState();
}

class DiceSquareState extends State<DiceSquare> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          //toggle hold
          widget.dice.rollHistory.isNotEmpty ? widget.dice.toggleHold(widget.index) : null;
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: widget.dice.isHeld(widget.index)
              ? const Color.fromARGB(255, 204, 184, 2)
              : const Color.fromARGB(255, 162, 162, 162),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            (widget.dice.values.length > widget.index)
                ? widget.dice.values[widget.index].toString()
                : '',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
