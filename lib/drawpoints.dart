import 'prerun.dart';
import 'package:flutter/material.dart';
import 'dart:math'
    as math; // Importieren der Klasse Random aus der Standardbibliothek von Dart

/*schon in prerun definiert
String palletteType = "linear";
List<double> paletteH = List<double>.filled(16, 0.0); // Create a list of 16 elements, all initialized to 0.0
List<double> paletteS = List<double>.filled(16, 0.0); // Create a list of 16 elements, all initialized to 0.5
List<double> paletteL = List<double>.filled(16, 0.0); // Create a list of 16 elements, all initialized to 0.5
 */

Padding myPaletteElement(int index) {
  const double palettSize = 50;

  switch (palletteType) {
    case "linear":
      //print("HSL!");
      paletteH[0] = mch;
      paletteH[15] = mch2;
      paletteS[0] = mcs;
      paletteS[15] = mcs2;
      paletteL[0] = mcl;
      paletteL[15] = mcl2;
      
      double distanceH = paletteH[15] - paletteH[0];
      double distanceS = paletteS[15] - paletteS[0];
      double distanceL = paletteL[15] - paletteL[0];
      if (distanceH.abs() > 180)
        paletteH[15] -= 360; //Das Problem gibt es nur mit Hue
      distanceH = paletteH[15] - paletteH[0];
      double aH = (mch2 - mch) / 15.0;
      double bH = mch;
      double aS = (mcs2 - mcs) / 15.0;
      double bS = mcs;
      double aL = (mcl2 - mcl) / 15.0;
      double bL = mcl;
      //print(paletteH[0]);
      for (int i = 1; i < 15; i++) {
        paletteH[i] = aH * i.toDouble() + bH;
        paletteS[i] = aS * i.toDouble() + bS;
        paletteL[i] = aL * i.toDouble() + bL;
        if (paletteH[i] < 0) {
          paletteH[i] += 360;
        }
        print("$i ${paletteH[i]}");
      }
        if (paletteH[15] < 0) {
          paletteH[15] += 360;//zurück ins Positive (KRAUTCODE)
        }

        print("i ${paletteH[15]}");
      break;
    case "yretsym":
    case "henon":
  }

  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Container(
      width: palettSize,
      height: palettSize,
      decoration: BoxDecoration(
        color: HSLColor.fromAHSL(
                1, paletteH[index], paletteS[index], paletteL[index])
            .toColor(),
        borderRadius: BorderRadius.circular(palettSize / 2),
      ),
    ),
  );
}

class SunflowerPainter extends CustomPainter {
  static const seedRadius = 100.0;
  static const scaleFactor = 4;

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
    int index = rng.nextInt(16);
    final paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..color = HSLColor.fromAHSL(
              0.75, paletteH[index], paletteS[index], paletteL[index])
          .toColor();
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

  int get seedCount => seeds.floor(); //greatest int below

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
        /*drawer: Drawer(
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
        ),*/
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
//            Row(Text("Die Bilder sind noch Platzhalter")),
                    /*const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Die Bilder sind noch Platzhalter:",
                style: TextStyle(fontSize: 19),),
              ],
            ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myPaletteElement(0),
                        myPaletteElement(1),
                        myPaletteElement(2),
                        myPaletteElement(3),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myPaletteElement(4),
                        myPaletteElement(5),
                        myPaletteElement(6),
                        myPaletteElement(7),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myPaletteElement(8),
                        myPaletteElement(9),
                        myPaletteElement(10),
                        myPaletteElement(11),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myPaletteElement(12),
                        myPaletteElement(13),
                        myPaletteElement(14),
                        myPaletteElement(15),
                      ],
                    ),
                  ],
                ),
                /*color: Colors.transparent,
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
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//Ende