import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getMatchData() async {
  final preferences = await SharedPreferences.getInstance();

  // Create the csv with header and default values
  List<List> matchDataTable = [
    [
      "Team",
      "Taxi",
      "Auto Low Goal Scored",
      "Auto High Goal Scored",
      "Auto Low Goal Miss",
      "Auto High Goal Miss",
      "Teleop Low Goal Scored",
      "Teleop High Goal Scored",
      "Teleop Low Goal Miss",
      "Teleop High Goal Miss",
      "Foul",
      "Tech Foul",
      "Defensive",
      "Low Rung Success",
      "Mid Rung Success",
      "High Rung Success",
      "Traversal Rung Success",
      "Ranking Points",
      "Comments"
    ],
    ["", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "", ""]
  ];

  // Change the values to those stored in SharedPreferences.
  for (var key in matchDataTable[0]) {
    if (preferences.get(key).toString() != "null") {
      final Object? value;
      if (preferences.get(key).runtimeType == bool) {
        value = preferences.get(key) as bool ? 1 : 0;
      } else {
        value = preferences.get(key);
      }
      matchDataTable[1][matchDataTable[0].indexOf(key)] = value;
    }
  }

  // Add misc information to comments.
  String info = "";
  if (preferences.getBool("disabled") == true) info += "Disabled | ";
  if (preferences.getBool("incap") == true) info += "Incapacitated | ";
  if (preferences.getBool("late") == true) info += "Late | ";
  matchDataTable[1].last = info + matchDataTable[1].last;

  return matchDataTable[1];
}
