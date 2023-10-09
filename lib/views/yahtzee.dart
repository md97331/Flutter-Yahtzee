import 'package:flutter/material.dart';
import 'package:mp2/Widget/DiceDisplay.dart';
import 'package:mp2/Widget/ScoreCardDisplay.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

class Yahtzee extends StatefulWidget {
  const Yahtzee({Key? key}) : super(key: key);

  @override
  YahtzeeState createState() => YahtzeeState();
}

class YahtzeeState extends State<Yahtzee> {
  Dice dice = Dice(5); //5 dices 
  bool categoryPicked = false; //if a cateogry has been picked
  bool gameEnded = false; //if the game has ended
  ScoreCard scoreCard = ScoreCard(); //scorecard
  Set<ScoreCategory> pickedCategories = <ScoreCategory>{}; //picked categories
  int currentScore = 0; //current score

  void updateGameEnded([bool ended = false]) {
    // If the game has ended, update the state
    setState(() {
      gameEnded = ended;
    });
  }

  void onTurnEnd() {
    bool allCategoriesPicked = ScoreCategory.values.every((category) =>
        scoreCard.isCategoryPicked(category) || scoreCard[category] != null);

    if (allCategoriesPicked) {
      // Show an AlertDialog with the score
      int tt = scoreCard.total;
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Game Over"),
            content: Text("Your score is: $tt"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      });
      dice.clear();
      currentScore = 0;
      scoreCard.clear();
      pickedCategories.clear();
    }
  }

  int calculateCurrentScore() {
    // Implement your logic to calculate the current score based on the scoreCard
    int score = 0;
    for (var category in ScoreCategory.values) {
      if (scoreCard.isCategoryPicked(category) && scoreCard[category] != null) {
        score += scoreCard[category]!;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    int newScore = calculateCurrentScore();
    return Scaffold(
      appBar: AppBar(title: const Text("Yahtzee")),
      body: Column(
        children: [
          DiceWindow(
              dice: dice,
              categoryPicked: categoryPicked), // Pass categoryPicked
          ScoreCardView(
              scoreCard: scoreCard,
              dice: dice,
              onTurnEnd: onTurnEnd,
              categoryPicked: categoryPicked,
              updateGameEnded: updateGameEnded,
              gameEnded: gameEnded),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Current Score: $newScore",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ) // Pass categoryPicked
        ],
      ),
    );
  }
}