import 'prerun.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;// Importieren der Klasse Random aus der Standardbibliothek von Dart

class SunflowerPainter extends CustomPainter {
  static const seedRadius = 150.0;
  static const scaleFactor = 4;
//  static const tau = math.pi * 2;
//  static final phi = (math.sqrt(5) + 1) / 2;

  final int seeds;

  SunflowerPainter(this.seeds);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2;
    //delete later
  final scaleFactor = 4;
  final tau = math.pi * 2;
  final phi = (math.sqrt(5) + 1) / 2;

    for (var i = 0; i < seeds; i++) {
      final theta = i * tau / phi;
      final r = math.sqrt(i) * scaleFactor;
      final x = center + r * math.cos(theta);
      final y = center - r * math.sin(theta);
      final offset = Offset(x, y);
      if (!size.contains(offset)) {
        continue;
        /*In Dart ist continue ein Schlüsselwort, das in Schleifen 
        verwendet wird, um den Fluss der Kontrolle fortzusetzen. 
        Wenn eine continue Anweisung in einer Schleife aufgerufen wird, 
        wird die aktuelle Iteration übersprungen und die nächste Iteration 
        beginnt.*/
      }
      drawSeed(canvas, x, y);
    }
  }

  @override
  bool shouldRepaint(SunflowerPainter oldDelegate) {
    return oldDelegate.seeds != seeds;
  }

  // Draw a small circle representing a seed centered at (x,y).
  void drawSeed(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
//      ..color = primaryColor;
      ..color = Color.fromARGB(
          255, rng.nextInt(256), rng.nextInt(256), rng.nextInt(256));
    canvas.drawCircle(Offset(x, y), seedRadius, paint);
  }
}

class Sunflower extends StatefulWidget {
  const Sunflower({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SunflowerState();
  }
}

class _SunflowerState extends State<Sunflower> {
  double seeds = 100.0;
  double seeds2 = 100.0;

  int get seedCount => seeds.floor();//greatest int below

  @override
  Widget build(BuildContext context) {
    //const Color bgCol = Color.fromARGB(255, 200, 200, 200);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        useMaterial3: true,
        platform: platform,
        brightness: Brightness.dark,
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: primaryColor,
          primaryColorLight: primaryColor,
          primaryColorDark: primaryColor,
          valueIndicatorTextStyle: const DefaultTextStyle.fallback().style,
        ),
      ),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: const [
              DrawerHeader(
                child: Center(
                  child: Text(
                    "I was a Sunflower 🌻",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
                child: SizedBox(
                  width: 400,
                  height: 400,
                  //https://api.flutter.dev/flutter/widgets/CustomPaint-class.html
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: SunflowerPainter(seedCount),
                    ),
                  ),
                ),
              ),
              //Text("Showing $seedCount seeds"),
              Container(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 300),
                  child: Slider.adaptive(
                    min: 3,
                    max: 1450,
                    value: seeds,
                    onChanged: (newValue) {
                      setState(() {
                        seeds = newValue;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//Ende