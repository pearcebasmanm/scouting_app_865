import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  //copied from https://stackoverflow.com/a/52678686/18758848
  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final _teamNumberController = TextEditingController();

  Future _getData() async {
    final preferences = await SharedPreferences.getInstance();
    setState(
        () => _teamNumberController.text = preferences.getString("Team") ?? "");
  }

  Future _saveData() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("Team", _teamNumberController.text);
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
    return AppBar(
      title: Row(
        children: [
          Text("${MediaQuery.of(context).size.width}Team Number:"),
          const SizedBox(width: 10),
          Container(
            width: 50,
            alignment: Alignment.center,
            child: TextField(
              maxLength: 4,
              keyboardType: TextInputType.number,
              controller: _teamNumberController,
              onChanged: (_) async {
                final preferences = await SharedPreferences.getInstance();
                preferences.setString("Team", _teamNumberController.text);
              },
              decoration: const InputDecoration(
                counterText: "",
                hintText: "",
                // suffixIcon: null,
                isCollapsed: true,
              ),
              /* Style taken from AppBar (ctrl-click to see source data)
              - titleTextStyle (10/29)
              - foregroundColor (which titleTextStyle references) (12/27)
              */
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Theme.of(context).colorScheme.brightness ==
                          Brightness.dark
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () async {
            setState(() => _teamNumberController.text = "");
            final preferences = await SharedPreferences.getInstance();
            preferences.setString("Team", "");
          },
        ),
      ],
    );
  }
}
