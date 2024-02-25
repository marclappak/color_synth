import 'package:flutter/material.dart';
import 'prerun.dart';
//import 'globals.dart';
import 'starter.dart';
import 'color_wheel.dart';
import 'drawpoints.dart';

void main() {
  initColorWheel(canvaWidth, canvaHeight);
  runApp(const WithBottomNavigationBarApp());
}
//void main() => runApp(const WithBottomNavigationBarApp());

class WithBottomNavigationBarApp extends StatelessWidget {
 const WithBottomNavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      debugShowCheckedModeBanner: false,
      home: WithBottomNavigationBar(),
    );
  }
}

class WithBottomNavigationBar extends StatefulWidget {
  WithBottomNavigationBar({super.key});

  @override
  State<WithBottomNavigationBar> createState() =>
      _WithBottomNavigationBarState();
}

class _WithBottomNavigationBarState
    extends State<WithBottomNavigationBar> {
  int _selectedIndex = 0;
  //static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Palette(),
    Tuning(),
    Export(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    appBarHeight = AppBar().preferredSize.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight =
        MediaQuery.of(context).size.height - appBarHeight - wantedRest;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgCol,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'the ColorSynth',
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: bgCol,
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Palette',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Tune',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Export',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
//    return MyHomePage();
    return const Starter();
    //return const Text("Hallo, Leute!");
  }
}

class Palette extends StatelessWidget {
  const Palette({super.key});
  @override
  Widget build(BuildContext context) {
    return ColorPicker();
  }
}

class Tuning extends StatelessWidget {
  const Tuning({super.key});
  @override
  Widget build(BuildContext context) {
    return const Sunflower();
  }
}

class Export extends StatelessWidget {
  const Export({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text("Hier werden die Codes exportiert.");
  }
}
