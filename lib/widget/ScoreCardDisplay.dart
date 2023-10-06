import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

class ScoreCardView extends StatelessWidget {
  final ScoreCard scoreCard;
  final Dice dice;
  final VoidCallback onTurnEnd;
  final bool categoryPicked;
  final Function(bool) updateGameEnded;
  final bool gameEnded; // Add gameEnded as a parameter

  const ScoreCardView({super.key, 
    required this.scoreCard,
    required this.dice,
    required this.onTurnEnd,
    required this.categoryPicked,
    required this.updateGameEnded,
    required this.gameEnded, // Add gameEnded as a named parameter
  });

  @override
  Widget build(BuildContext context) {
    const categories = ScoreCategory.values;
    final halfLength = (categories.length / 2).ceil();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories
                .take(halfLength)
                .map(
                  (category) => ScoreCardTile(
                    category: category,
                    scoreCard: scoreCard,
                    dice: dice,
                    onPick: () {
                      scoreCard.registerScore(category, dice.values.toList());
                      dice.clear();
                      onTurnEnd();
                    },
                    gameEnded: gameEnded,
                    updateGameEnded: updateGameEnded,
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories
                .skip(halfLength)
                .map(
                  (category) => ScoreCardTile(
                    category: category,
                    scoreCard: scoreCard,
                    dice: dice,
                    onPick: () {
                      scoreCard.registerScore(category, dice.values.toList());
                      dice.clear();
                      onTurnEnd();
                    },
                    gameEnded: gameEnded,
                    updateGameEnded: updateGameEnded,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class ScoreCardTile extends StatefulWidget {
  final ScoreCategory category;
  final ScoreCard scoreCard;
  final Dice dice;
  final VoidCallback onPick;
  final Function(bool) updateGameEnded;
  final bool gameEnded; // Add gameEnded as a parameter

  const ScoreCardTile({super.key, 
    required this.category,
    required this.scoreCard,
    required this.dice,
    required this.onPick,
    required this.updateGameEnded,
    required this.gameEnded, // Add gameEnded as a named parameter
  });

  @override
  ScoreCardTileState createState() => ScoreCardTileState();
}

class ScoreCardTileState extends State<ScoreCardTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Add some elevation for a card-like effect
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add some margin
      child: ListTile(
        title: Text(
          widget.category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: widget.scoreCard.isCategoryPicked(widget.category)
            ? Text(
                widget.scoreCard[widget.category].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Change color for picked categories
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 158, 158, 158), // Change button color here
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  widget.updateGameEnded(
                      false); // Call the callback without arguments
                  if (widget.gameEnded == false &&
                      widget.dice.rolls > 0 &&
                      !widget.scoreCard.isCategoryPicked(widget.category)) {
                    widget.onPick();
                    widget.dice.clear(); // Clear the dice rolls

                    bool allCategoriesPicked = ScoreCategory.values.every(
                        (category) =>
                            widget.scoreCard.isCategoryPicked(category) ||
                            widget.scoreCard[category] != null);

                    if (allCategoriesPicked) {
                      widget.updateGameEnded(
                          true); // Call the callback function to update gameEnded
                    }
                  }
                },
                child: const Text("Pick"),
              ),
      ),
    );
  }
}
