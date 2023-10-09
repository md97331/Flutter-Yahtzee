import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

class ScoreCardView extends StatelessWidget {
  final ScoreCard scoreCard; //scorecard
  final Dice dice; // Dice (window)
  final VoidCallback onTurnEnd; //function to call when turn ends
  final bool categoryPicked; //know if category has been picked
  final Function(bool) updateGameEnded; //update game ended
  final bool gameEnded; //know if game has ended

  const ScoreCardView({super.key, 
    Key? lkey,
    required this.scoreCard,
    required this.dice,
    required this.onTurnEnd,
    required this.categoryPicked,
    required this.updateGameEnded,
    required this.gameEnded,
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
  final ScoreCategory category; //category
  final ScoreCard scoreCard; //scorecard
  final Dice dice; // Dice (window)
  final VoidCallback onPick;  //function to call when category is picked
  final Function(bool) updateGameEnded; //update game ended
  final bool gameEnded; //know if game has ended

  const ScoreCardTile({super.key, 
    Key? lkey,
    required this.category,
    required this.scoreCard,
    required this.dice,
    required this.onPick,
    required this.updateGameEnded,
    required this.gameEnded,
  });

  @override
  ScoreCardTileState createState() => ScoreCardTileState();
}

class ScoreCardTileState extends State<ScoreCardTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  color: Colors.green,
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 158, 158, 158),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  widget.updateGameEnded(false);
                  if (widget.gameEnded == false &&
                      widget.dice.rolls > 0 &&
                      !widget.scoreCard.isCategoryPicked(widget.category)) {
                    widget.onPick();
                    widget.dice.clear();

                    bool allCategoriesPicked = ScoreCategory.values.every(
                      (category) =>
                          widget.scoreCard.isCategoryPicked(category) ||
                          widget.scoreCard[category] != null,
                    );

                    if (allCategoriesPicked) {
                      widget.updateGameEnded(true);
                    }
                  }
                },
                child: const Text("Pick"),
              ),
      ),
    );
  }
}
