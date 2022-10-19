import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/counter.dart';
import '../widgets/toggle_button.dart';

class AutoPage extends StatefulWidget {
  const AutoPage({Key? key}) : super(key: key);

  @override
  State<AutoPage> createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  int _lowHits = 0;
  int _highHits = 0;
  int _lowMisses = 0;
  int _highMisses = 0;
  bool _taxi = false;

  Future _getData() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _taxi = preferences.getBool("Taxi") ?? false;
      _lowHits = preferences.getInt("Auto Low Goal Scored") ?? 0;
      _highHits = preferences.getInt("Auto High Goal Scored") ?? 0;
      _lowMisses = preferences.getInt("Auto Low Goal Miss") ?? 0;
      _highMisses = preferences.getInt("Auto High Goal Miss") ?? 0;
    });
  }

  Future _saveData() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool("Taxi", _taxi);
    await preferences.setInt("Auto Low Goal Scored", _lowHits);
    await preferences.setInt("Auto High Goal Scored", _highHits);
    await preferences.setInt("Auto Low Goal Miss", _lowMisses);
    await preferences.setInt("Auto High Goal Miss", _highMisses);
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
    return Flex(
      direction: Axis.vertical,
      children: [
        ToggleButton(
          text: "Taxi",
          value: _taxi,
          onPressed: () => setState(() => _taxi = !_taxi),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Low",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "High",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: Card(
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: Counter(
                          label: "Scored:",
                          value: _lowHits,
                          onIncrease: () => setState(() => _lowHits++),
                          onDecrease: () => setState(() {
                            if (_lowHits > 0) _lowHits--;
                          }),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                        height: 0,
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Counter(
                          label: "Missed:",
                          value: _lowMisses,
                          onIncrease: () => setState(() => _lowMisses++),
                          onDecrease: () => setState(() {
                            if (_lowMisses > 0) _lowMisses--;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: Counter(
                          label: "Scored:",
                          value: _highHits,
                          onIncrease: () => setState(() => _highHits++),
                          onDecrease: () => setState(() {
                            if (_highHits > 0) _highHits--;
                          }),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                        height: 0,
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Counter(
                          label: "Missed:",
                          value: _highMisses,
                          onIncrease: () => setState(() => _highMisses++),
                          onDecrease: () => setState(() {
                            if (_highMisses > 0) _highMisses--;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
