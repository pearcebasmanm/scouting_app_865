import 'package:flutter/material.dart';
import 'package:scouting_app_865/utils/theme.dart';
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

  Future _setData(value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("Team", value);
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Team Number:"),
          const SizedBox(width: 10),
          Container(
            width: 47,
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(width: 1, color: palette().onPrimary),
              ),
            ),
            child: TextField(
              maxLength: 4,
              controller: _teamNumberController,
              onChanged: (value) => _setData(value),
              style: TextStyle(
                fontSize: 20,
                color: palette().onPrimary,
              ),
              decoration: null, // isn't null by default, so don't remove
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: () {
              setState(() => _teamNumberController.text = "");
              _setData("");
            },
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}
