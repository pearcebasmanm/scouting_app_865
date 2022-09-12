import "package:csv/csv.dart";
import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";

class QRPage extends StatefulWidget {
  // final Function resetParentData;

  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String data = "";

  Future _getData() async {
    final preferences = await SharedPreferences.getInstance();

    // Create the csv with header and default values
    List<List> csvList = [
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
    for (var key in csvList[0]) {
      if (preferences.get(key).toString() != "null") {
        final Object? value;
        if (preferences.get(key).runtimeType == bool) {
          value = preferences.get(key) as bool ? 1 : 0;
        } else {
          value = preferences.get(key);
        }
        csvList[1][csvList[0].indexOf(key)] = value;
      }
      // print("$key: ${csvList[1][csvList[0].indexOf(key)]}");
    }

    // Add info page information to comments.
    String info = "";
    if (preferences.getBool("disabled") == true) info += "Disabled | ";
    if (preferences.getBool("incap") == true) info += "Incapacitated | ";
    if (preferences.getBool("late") == true) info += "Late | ";
    csvList[1].last = info + csvList[1].last;

    setState(() => data = const ListToCsvConverter().convert([csvList[1]]));
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        QrImage(data: data),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: SelectableText(
            data,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        TextButton(
          child: const Text("Reset Data"),
          onPressed: () {
            // ignore: invalid_use_of_visible_for_testing_member
            SharedPreferences.setMockInitialValues({});
            // widget.resetParentData;
          },
        )
      ],
    );
  }
}
