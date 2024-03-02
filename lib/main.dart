import 'package:flutter/material.dart';
import 'prerun.dart';
//import 'globals.dart';
import 'starter.dart';
import 'color_wheel.dart';
import 'drawpoints.dart';
//import 'dart:io';
//import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
/*
if (Platform.isAndroid) {
  print('Running on Android');
} else if (Platform.isIOS) {
  print('Running on iOS');
} else if (Platform.isLinux) {
  print('Running on Linux');
} else if (Platform.isWindows) {
  print('Running on Windows');
} else if (Platform.isMacOS) {
  print('Running on macOS');
} else if (kIsWeb) {
  print('Running in a web browser');
}*/

  //initColorWheel(canvaWidth, canvaHeight);
  initColorWheel(215, 215);
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

class _WithBottomNavigationBarState extends State<WithBottomNavigationBar> {
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
    return const MyFlower();
  }
}

class Export extends StatelessWidget {
  const Export({super.key});
  @override
  Widget build(BuildContext context) {
      String outputText = "here are the hex-codes:\n";
    for (int i = 0; i < 16; i++) {
      Color tempColor = HSLColor.fromAHSL(1, paletteH[i], paletteS[i], paletteL[i]).toColor();
      int r = (tempColor.red).toInt();
      int g = (tempColor.green).toInt();
      int b = (tempColor.blue).toInt();
      int theCode=r*256*256+g*256+b;
      String hexCode = theCode.toRadixString(16);
      //print("hexCode=$hexCode");

    outputText += "color$i='$hexCode'\n";
    }
    return SelectableText("$outputText");
  }
}
