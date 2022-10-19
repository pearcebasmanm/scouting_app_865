import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/get_match_data.dart';
import '../utils/gsheets_api.dart';
import '../widgets/action_button.dart';
import '../widgets/toggle_button.dart';

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
        ToggleButton(
          text: "Disabled",
          value: _disabled,
          onPressed: () => setState(() => _disabled = !_disabled),
        ),
        ToggleButton(
          text: "Incapacitated",
          value: _incapacitated,
          onPressed: () => setState(() => _incapacitated = !_incapacitated),
        ),
        ToggleButton(
          text: "Started Late",
          value: _late,
          onPressed: () => setState(() => _late = !_late),
        ),
        ActionButton(
          onPressed: () async {
            _saveData();
            GSheetsAPI.addRow(await getMatchData());
          },
          child: const Text("Send Data"),
        ),
        if (!kIsWeb)
          ActionButton(
            onPressed: () {
              _saveData();
              widget.qrButtonFunction();
            },
            child: const Text("QR Code"),
          ),
        ActionButton(
          child: const Text("Reset Data"),
          onPressed: () {
            _saveData();
            // ignore: invalid_use_of_visible_for_testing_member
            SharedPreferences.setMockInitialValues({});
            _getData();
          },
        ),
        ActionButton(
          onPressed: () => widget.startTimer(),
          child: const Text("Start/Stop Auto"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(labelText: "Comments"),
            // maxLines: 10,
          ),
        ),
      ],
    );
  }
}
