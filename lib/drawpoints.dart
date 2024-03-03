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
      /*     double distanceS = paletteS[15] - paletteS[0];
      double distanceL = paletteL[15] - paletteL[0];*/
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
//        print("$i ${paletteH[i]}");
      }
      if (paletteH[15] < 0) {
        paletteH[15] += 360; //zurück ins Positive (KRAUTCODE)
      }

     // print("i ${paletteH[15]}");
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

class MyFlowerPainter extends CustomPainter {
  //static const seedRadius = drawSlider1;
  double seedRadius = drawSlider1;
  static const scaleFactor = 4;
  int seeds = 10;/*
  int par1;
  int par2;
  int par3;
  double drawSlider1=0, drawSlider2=0, drawSlider3=0;*/
  //int val=30;
  MyFlowerPainter(this.seeds);
  //MyFlowerPainter(this.seeds);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2;
    final tau = math.pi * 2;
    final phi = (math.sqrt(5) + 1) / 2;
        //print(drawSlider1);
    for (var i = 0; i < drawSlider2.toInt(); i++) {
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
  bool shouldRepaint(MyFlowerPainter oldDelegate) {
    return oldDelegate.seeds != seeds;
  }

  // Draw a small circle representing a seed centered at (x,y).
  void drawSeed(Canvas canvas, double x, double y) {
    int index = rng.nextInt(16);
    final paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..color = HSLColor.fromAHSL(
              drawSlider3, paletteH[index], paletteS[index], paletteL[index])
          .toColor();
    canvas.drawCircle(Offset(x, y), seedRadius, paint);
  }
}

class MyFlower extends StatefulWidget {
  const MyFlower({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyFlowerState();
  }
}

class _MyFlowerState extends State<MyFlower> {
  double seeds = 100.0;
  int val1 = 30;
  int val2 = 40;
  int val3 = 50;
  int get seedCount => seeds.floor();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        useMaterial3: true,
        brightness: Brightness.dark,
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: primaryColor,
          primaryColorLight: primaryColor,
          primaryColorDark: primaryColor,
          valueIndicatorTextStyle: const DefaultTextStyle.fallback().style,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Draw some samples"),
        ),
        drawer: Drawer(
          child: ListView(
            children: const [
              DrawerHeader(
                child: Center(
                  child: Text(
                    "here you can test some layouts with your color-palette",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: SizedBox(
                  width: canvaWidth,
                  height: canvaHeight,
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: MyFlowerPainter(val1),
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //add vertical sliders
                    RotatedBox(
                      quarterTurns: -1, // Rotate 90 degrees (vertical)
                      child: Slider(
                        value: drawSlider1,
                        min: 1.0,
                        max: 100.0,
                        divisions: 50,
                        onChanged: (double newValue) {
                          setState(() {
                            drawSlider1 = newValue;
                          });
                        },
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: -1, // Rotate 90 degrees (vertical)
                      child: Slider(
                        value: drawSlider2,
                        min: 0.0,
                        max: 50.0,
                        divisions: 50,
                        onChanged: (double newValue) {
                          setState(() {
                            drawSlider2 = newValue;
                          });
                        },
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: -1, // Rotate 90 degrees (vertical)
                      child: Slider(
                        value: drawSlider3,
                        min: 0.0,
                        max: 1.0,
                        divisions: 50,
                        onChanged: (double newValue) {
                          setState(() {
                            drawSlider3 = newValue;
                          });
                        },
                      ),
                    ),
                  ],
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