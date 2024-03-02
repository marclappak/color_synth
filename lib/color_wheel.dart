import 'package:flutter/material.dart';
import 'prerun.dart';

const Color primaryColor = Colors.grey;
const TargetPlatform platform = TargetPlatform.android;

void myWheel() {//used to be main
//  canvaWidth = size.width;
  initColorWheel(canvaWidth, canvaHeight); //dauert lange 
  runApp(ColorPicker());
}

Padding myPaletteElement(int index) {
  const double palettSize = 40;

  switch (palletteType) {
    case "linear":
      //print("HSL!");
      paletteH[0] = mch;
      paletteH[15] = mch2;
      paletteS[0] = mcs;
      paletteS[15] = mcs2;
      paletteL[0] = mcl;
      paletteL[15] = mcl2;
      
//kürzeste Strecke bestimmen

  double Strecke;
  if (paletteH[0] < paletteH[15]) {
    if (paletteH[15] - paletteH[0] < 180.0) {
      Strecke = paletteH[15] - paletteH[0];
    } else {
      //Richtungswechsel
      Strecke = paletteH[15] - paletteH[0] - 360.0;
    }
  } else {
    if (paletteH[0] - paletteH[15] < 180.0) {
      Strecke = paletteH[15]-paletteH[0];
    } else {
      //Richtungswechsel
      Strecke = 360 + paletteH[15] - paletteH[0];
    }
  }
  








/*      double distanceH = paletteH[15] - paletteH[0];
      if (distanceH.abs() > 180)
        paletteH[15] -= 360; //Das Problem gibt es nur mit Hue
      distanceH = paletteH[15] - paletteH[0];*/
      double aH =Strecke / 15.0;
      double bH = mch;
      double aS = (mcs2 - mcs) / 15.0;//kein Kreis, einfacher
      double bS = mcs;
      double aL = (mcl2 - mcl) / 15.0;//kein Kreis, einfacher
      double bL = mcl;
      //print(paletteH[0]);
      for (int i = 0; i < 16; i++) {
        paletteH[i] = aH * i.toDouble() + bH;
        paletteS[i] = aS * i.toDouble() + bS;
        paletteL[i] = aL * i.toDouble() + bL;
        if (paletteH[i] < 0) paletteH[i]   += 360;//zurück ins Positive muss sein
        if (paletteH[i] > 360) paletteH[i] -= 360;//muss unter 360 bleiben
        
        //print("$i ${paletteH[i]}");
      }

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


class ColorPickerPainter extends CustomPainter {
  static const dotRadius = 1.5;
  final int lum;
  ColorPickerPainter(this.lum);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < numCanvaPoints; i++) {
       drawSeed(canvas, wheelX[i].toDouble(), wheelY[i].toDouble(), wheelH[i],
          2*wheelR[i] / canvaWidth);
    }
  }

  @override
  bool shouldRepaint(ColorPickerPainter oldDelegate) {
    return oldDelegate.lum != lum;
  }

  // Draw a small circle representing a dot centered at (x,y).
  void drawSeed(Canvas canvas, double x, double y, double h, double s) {
    if (h >= 0) {
      final paint = Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.fill
        ..color = HSLColor.fromAHSL(1, h, s, lum/100.0).toColor();

      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }
}

class ColorPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ColorPickerState();
  }
}

class _ColorPickerState extends State<ColorPicker> {
  int get lumi => lum.floor();
  Color _containerColor1 = mainColor; // Initial color
  Color _containerColor2 = mainColor; // Initial color

  void _changeColor() {
    setState(() {
      // Change the color to a different one
      //print("mcs=$mcs");
      _containerColor1 = HSLColor.fromAHSL(1, mch, mcs, mcl).toColor();
      _containerColor2 = HSLColor.fromAHSL(1, mch2, mcs2, mcl2).toColor();
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
       // platform: platform,
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
          title: const Text("ColorPicker & Palette"),
        ),
        drawer: Drawer(
          child: ListView(
            
            children: const [
              DrawerHeader(
                child: Center(
                  child: Text(
                    "ColorPicker help\nchoose two colors by tapping the color wheel.\nYou can also set the luminosity\nwith the slider.\n THE COLOR-PALETTE IS SHOWN IMMEDIATELY√\nmade by Marc Lingk for App-Akademie Berlin",
                    style: TextStyle(fontSize: 12),
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
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                    ),
                    child: SizedBox(
                      width:  canvaWidth,
                      height: canvaHeight,                      
                      child: GestureDetector(
                       onTapDown: (TapDownDetails details) {
                          double x = details.localPosition.dx;
                          double y = details.localPosition.dy;
                          int index = (y * canvaWidth + x).toInt();
                            getHue(x, y,lumi.toDouble() / 100.0);
                            _changeColor();
                        },					
                        child: CustomPaint(
                          painter: ColorPickerPainter(lumi),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              Row(//der Light-Slider
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" Light:"),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 250),
                    child: Slider.adaptive(
                      min: minLumi,
                      max: 100,
                      value: lum,
                      onChanged: (newValue) {
                        setState(() {
                          lum = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
/*            Container(
             child: Text("main color set to:")
            ),*/
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: _containerColor1,
                )
            ),
            Container(
             //child: Text("secondary color set to:")
             child: Text("---------------------------------->")
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: _containerColor2,
                )
            ),
          ],
        ),
        /*
            Container(//Platzhalter
              height: 30,
              width: 80,),
*/
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
