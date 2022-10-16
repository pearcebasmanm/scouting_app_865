import 'package:flutter/material.dart';
import 'package:scouting_app_865/utils/get_match_data.dart';
import 'package:scouting_app_865/utils/gsheets_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/button.dart';

class HomePage extends StatefulWidget {
  final Function qrButtonFunction;
  final Function startTimer;

  const HomePage({
    required this.qrButtonFunction,
    required this.startTimer,
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _commentController = TextEditingController();
  bool _disabled = false;
  bool _incapacitated = false;
  bool _late = false;

  Future _getData() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _disabled = preferences.getBool("disabled") ?? false;
      _incapacitated = preferences.getBool("incap") ?? false;
      _late = preferences.getBool("late") ?? false;
      _commentController.text = preferences.getString("Comments") ?? "";
    });
  }

  Future _saveData() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool("disabled", _disabled);
    preferences.setBool("incap", _incapacitated);
    preferences.setBool("late", _late);
    preferences.setString("Comments", _commentController.text);
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
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        CustomButton(
          text: "Disabled",
          value: _disabled,
          onPressed: () => setState(() => _disabled = !_disabled),
        ),
        CustomButton(
          text: "Incapacitated",
          value: _incapacitated,
          onPressed: () => setState(() => _incapacitated = !_incapacitated),
        ),
        CustomButton(
          text: "Started Late",
          value: _late,
          onPressed: () => setState(() => _late = !_late),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(labelText: "Comments"),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
            onPressed: () async {
              _saveData();
              GSheetsAPI.addRow(await getMatchData());
            },
            child: const Text("Send Data"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
            onPressed: () {
              _saveData();
              widget.qrButtonFunction();
            },
            child: const Text("QR Code"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
            onPressed: () => widget.startTimer(),
            child: const Text("Start/Stop Auto"),
          ),
        ),
      ],
    );
  }
}
