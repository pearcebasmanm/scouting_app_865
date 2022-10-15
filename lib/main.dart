import 'dart:async';
import 'package:flutter/material.dart';
import './utils/gsheets_api.dart';
import './pages/auto_page.dart';
import './pages/endgame_page.dart';
import './pages/home_page.dart';
import './pages/teleop_page.dart';
import './pages/qr_page.dart';
import './utils/appbar.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GSheetsAPI.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.from(colorScheme: const ColorScheme.light()),
      theme: theme(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _timerIsVisible = false;
  int _time = 0;
  final _pageController = PageController();
  int _selectedPage = 0;

  void _startTimer() async {
    if (_timerIsVisible) {
      setState(() => _timerIsVisible = false);
      return;
    }

    // Move to Auto tab and show the timer
    _navigate(1);
    setState(() => _timerIsVisible = true);

    for (int i = 150; i > 0; i--) {
      if (!_timerIsVisible) return;

      setState(() => _time = i % 135);
      // Move to Teleop tab at the 15-second mark (150 - 15 = 135)
      if (i == 135) _navigate(2);

      await Future.delayed(const Duration(seconds: 1));
    }

    // Move to Endgame tab and hide timer
    _navigate(3);
    setState(() => _timerIsVisible = false);
  }

  // Page Navigation
  late final List<Widget> _pages = [
    HomePage(
      qrButtonFunction: () => _navigate(4),
      startTimer: _startTimer,
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
        resizeToAvoidBottomInset: false, //mobile keyboard appears over elements
        appBar: const CustomAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(5),
          // PageView makes tabs swipable on mobile app
          child: PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: (i) => setState(() => _selectedPage = i),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: palette().primary,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTabItem(index: 0, icon: Icons.home, label: "Main"),
              buildTabItem(index: 1, icon: Icons.computer, label: "Auto"),
              if (_timerIsVisible) const SizedBox(width: 30),
              buildTabItem(
                  index: 2, icon: Icons.videogame_asset, label: "Teleop"),
              buildTabItem(index: 3, icon: Icons.timer, label: "Endgame"),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _timerIsVisible
            ? FloatingActionButton(
                onPressed: null,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "$_time",
                      style: const TextStyle(fontSize: 100), // shrinks to size
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    // Contrasting color when the tab is selected, otherwise the secondary color
    Color barItemColor =
        _selectedPage == index ? palette().onPrimary : palette().secondary;

    return MaterialButton(
      onPressed: () => _navigate(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: barItemColor),
            Text(label, style: TextStyle(color: barItemColor))
          ],
        ),
      ),
    );
  }
}
