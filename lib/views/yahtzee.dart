import 'package:flutter/material.dart';
import 'package:mp2/Widget/DiceDisplay.dart';
import 'package:mp2/Widget/ScoreCardDisplay.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

class Yahtzee extends StatefulWidget {
  const Yahtzee({Key? key}) : super(key: key);

  @override
  _YahtzeeState createState() => _YahtzeeState();
}

class _YahtzeeState extends State<Yahtzee> {
  Dice dice = Dice(5);
  bool categoryPicked = false;
  bool gameEnded = false;
  ScoreCard scoreCard = ScoreCard();
  Set<ScoreCategory> pickedCategories = <ScoreCategory>{};
  int currentScore = 0;

  void updateGameEnded([bool ended = false]) {
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

// class DiceWindow extends StatefulWidget {
//   final Dice dice;
//   final bool categoryPicked;

//   const DiceWindow({Key? key, required this.dice, required this.categoryPicked})
//       : super(key: key);

//   @override
//   DiceWindowState createState() => DiceWindowState();
// }

// class DiceWindowState extends State<DiceWindow> {
//   @override
//   Widget build(BuildContext context) {
//     String buttonText = (widget.dice.rolls < 3 || widget.categoryPicked)
//         ? "Roll Dice"
//         : "No More Rolls"; // Define the button text

//     return Column(
//       children: [
//         Row(
//           children: [
//             for (int i = 0; i < 5; i++)
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DiceSquare(index: i, dice: widget.dice),
//                 ),
//               ),
//           ],
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             primary: Color.fromARGB(255, 255, 255, 255), // Change button color here
//             textStyle: TextStyle(fontSize: 16),
//           ),
//           onPressed: (widget.dice.rolls < 3) ? () => rollDice() : null,
//           child: Text(buttonText), // Use the buttonText variable
//         ),
//       ],
//     );
//   }

//   void rollDice() {
//     setState(() {
//       widget.dice.roll();
//     });
//   }
// }

// class DiceSquare extends StatefulWidget {
//   final int index;
//   final Dice dice;

//   const DiceSquare({Key? key, required this.index, required this.dice})
//       : super(key: key);

//   @override
//   DiceSquareState createState() => DiceSquareState();
// }

// class DiceSquareState extends State<DiceSquare> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           widget.dice.toggleHold(widget.index);
//         });
//       },
//       child: Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: widget.dice.isHeld(widget.index)
//               ? Color.fromARGB(255, 204, 184, 2)
//               : Color.fromARGB(255, 162, 162, 162), // Change square color here
//           borderRadius: BorderRadius.circular(10), // Add some border radius
//         ),
//         child: Center(
//           child: Text(
//             (widget.dice.values.length > widget.index &&
//                     widget.dice.values[widget.index] != null)
//                 ? widget.dice.values[widget.index]!.toString()
//                 : '',
//             style: const TextStyle(fontSize: 24, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ScoreCardView extends StatelessWidget {
//   final ScoreCard scoreCard;
//   final Dice dice;
//   final VoidCallback onTurnEnd;
//   final bool categoryPicked;
//   final Function(bool) updateGameEnded;
//   final bool gameEnded; // Add gameEnded as a parameter

//   ScoreCardView({
//     required this.scoreCard,
//     required this.dice,
//     required this.onTurnEnd,
//     required this.categoryPicked,
//     required this.updateGameEnded,
//     required this.gameEnded, // Add gameEnded as a named parameter
//   });

//   @override
//   Widget build(BuildContext context) {
//     final categories = ScoreCategory.values;
//     final halfLength = (categories.length / 2).ceil();

//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: categories
//                 .take(halfLength)
//                 .map(
//                   (category) => ScoreCardTile(
//                     category: category,
//                     scoreCard: scoreCard,
//                     dice: dice,
//                     onPick: () {
//                       scoreCard.registerScore(category, dice.values.toList());
//                       dice.clear();
//                       onTurnEnd();
//                     },
//                     gameEnded: gameEnded,
//                     updateGameEnded: updateGameEnded,
//                   ),
//                 )
//                 .toList(),
//           ),
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: categories
//                 .skip(halfLength)
//                 .map(
//                   (category) => ScoreCardTile(
//                     category: category,
//                     scoreCard: scoreCard,
//                     dice: dice,
//                     onPick: () {
//                       scoreCard.registerScore(category, dice.values.toList());
//                       dice.clear();
//                       onTurnEnd();
//                     },
//                     gameEnded: gameEnded,
//                     updateGameEnded: updateGameEnded,
//                   ),
//                 )
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ScoreCardTile extends StatefulWidget {
//   final ScoreCategory category;
//   final ScoreCard scoreCard;
//   final Dice dice;
//   final VoidCallback onPick;
//   final Function(bool) updateGameEnded;
//   final bool gameEnded; // Add gameEnded as a parameter

//   ScoreCardTile({
//     required this.category,
//     required this.scoreCard,
//     required this.dice,
//     required this.onPick,
//     required this.updateGameEnded,
//     required this.gameEnded, // Add gameEnded as a named parameter
//   });

//   @override
//   _ScoreCardTileState createState() => _ScoreCardTileState();
// }

// class _ScoreCardTileState extends State<ScoreCardTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3, // Add some elevation for a card-like effect
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add some margin
//       child: ListTile(
//         title: Text(
//           widget.category.name,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         trailing: widget.scoreCard.isCategoryPicked(widget.category)
//             ? Text(
//                 widget.scoreCard[widget.category].toString(),
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green, // Change color for picked categories
//                 ),
//               )
//             : ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: Color.fromARGB(255, 158, 158, 158), // Change button color here
//                   textStyle: TextStyle(fontSize: 12),
//                 ),
//                 onPressed: () {
//                   widget.updateGameEnded(
//                       false); // Call the callback without arguments
//                   if (widget.gameEnded == false &&
//                       widget.dice.rolls > 0 &&
//                       !widget.scoreCard.isCategoryPicked(widget.category)) {
//                     widget.onPick();
//                     widget.dice.clear(); // Clear the dice rolls

//                     bool allCategoriesPicked = ScoreCategory.values.every(
//                         (category) =>
//                             widget.scoreCard.isCategoryPicked(category) ||
//                             widget.scoreCard[category] != null);

//                     if (allCategoriesPicked) {
//                       widget.updateGameEnded(
//                           true); // Call the callback function to update gameEnded
//                     }
//                   }
//                 },
//                 child: Text("Pick"),
//               ),
//       ),
//     );
//   }
// }
