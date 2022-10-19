import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/toggle_button.dart';

enum Rung { none, low, mid, high, traversal }

class EndgamePage extends StatefulWidget {
  const EndgamePage({Key? key}) : super(key: key);

  @override
  State<EndgamePage> createState() => _EndgamePageState();
}

class _EndgamePageState extends State<EndgamePage> {
  Rung _rung = Rung.none;

  Future _getData() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() => _rung = Rung.values[preferences.getInt("rung") ?? 0]);
  }

  Future _saveData() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt("rung", _rung.index);

    preferences.setBool("Low Rung Success", false);
    preferences.setBool("Mid Rung Success", false);
    preferences.setBool("High Rung Success", false);
    preferences.setBool("Traversal Rung Success", false);

    switch (_rung) {
      case Rung.none:
        break;
      case Rung.low:
        preferences.setBool("Low Rung Success", true);
        break;
      case Rung.mid:
        preferences.setBool("Mid Rung Success", true);
        break;
      case Rung.high:
        preferences.setBool("High Rung Success", true);
        break;
      case Rung.traversal:
        preferences.setBool("Traversal Rung Success", true);
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    _saveData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...Rung.values.map((rung) {
              return Expanded(
                child: ToggleButton(
                  text: rung.name[0].toUpperCase() + rung.name.substring(1),
                  value: rung,
                  groupValue: _rung,
                  onPressed: (Rung? value) => setState(() => _rung = value!),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
