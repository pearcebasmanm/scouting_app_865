import 'dart:async';
import 'package:flutter/material.dart';
import '../pages/auto_page.dart';
import '../pages/endgame_page.dart';
import '../pages/home_page.dart';
import '../pages/teleop_page.dart';
import '../pages/qr_page.dart';
import '../utils/appbar.dart';
import '../utils/themes.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme(Themes.light),
      home: const MyHomePage(),
    );
    // return FutureBuilder(
    //   future: getMaterialYouColors(),
    //   builder: (context, snapshot) {
    //     print(snapshot.data);
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       theme: CustomTheme.theme(Themes.light),
    //       home: const MyHomePage(),
    //     );
    //   },
    // );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showTimer = false;
  int _time = 0;
  int _timers = 0;
  final _pageController = PageController();
  int _selectedPage = 0;

  void _timer() async {
    if (_timers > 0) {
      setState(() => _showTimer = false);
      return;
    }

    // start of auto
    setState(() {
      _timers += 1;
      _navigate(1);
      _showTimer = true;
    });

    for (int i = 150; i > 0; i--) {
      if (_showTimer == false || _timers > 1) {
        setState(() {
          _timers -= 1;
        });
        return;
      }
      setState(() {
        _time = i % 135;
        if (i == 135) _navigate(2);
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _timers -= 1;
      _navigate(3);
      _showTimer = false;
    });
  }

  // Page Navigation
  late final List<Widget> _pages = <Widget>[
    HomePage(
      qrButtonFunction: () => _navigate(4),
      timer: _timer,
    ),
    const AutoPage(),
    const TeleopPage(),
    const EndgamePage(),
    const QRPage(),
  ];
  void _navigate(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTabItem(index: 0, icon: Icons.home, label: "Main"),
              buildTabItem(index: 1, icon: Icons.computer, label: "Auto"),
              if (_showTimer)
                const SizedBox(
                  width: 30,
                ),
              buildTabItem(
                  index: 2, icon: Icons.videogame_asset, label: "Teleop"),
              buildTabItem(index: 3, icon: Icons.timer, label: "Endgame"),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: (i) => setState(() => _selectedPage = i),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _showTimer
            ? FloatingActionButton(
                onPressed: null,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "$_time",
                      style: const TextStyle(
                        fontSize: 100, // shrinks to size
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget buildTabItem(
      {required int index, required IconData icon, required String label}) {
    Color? barItemColor = _selectedPage == index
        ? Theme.of(context).colorScheme.inversePrimary
        : Color.lerp(Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.inversePrimary, 0.5);

    return MaterialButton(
      onPressed: () => _navigate(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: barItemColor,
          ),
          Text(
            label,
            style: TextStyle(color: barItemColor),
          )
        ],
      ),
    );

    // IconButton(
    //   icon: icon,
    //   onPressed: () => _navigate(index),
    //   color: _selectedPage == index
    //       ? Theme.of(context).colorScheme.inversePrimary
    //       : Color.lerp(Theme.of(context).colorScheme.primary,
    //           Theme.of(context).colorScheme.inversePrimary, 0.5),
    // );
  }
}
