import 'package:flutter/material.dart';
import 'prerun.dart';

const Color primaryColor = Colors.grey;
const TargetPlatform platform = TargetPlatform.android;

void myWheel() {//used to be main
//  canvaWidth = size.width;
  initColorWheel(canvaWidth.toDouble(), canvaHeight.toDouble()); //dauert lange 
  getHue(109, 100);
  runApp(ColorPicker());
}

class ColorPickerPainter extends CustomPainter {
  static const dotRadius = 1.5;
  final int lum;
  ColorPickerPainter(this.lum);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < numCanvaPoints; i++) {
       drawSeed(canvas, wheelX[i].toDouble(), wheelY[i].toDouble(), wheelH[i],
          wheelR[i] / 185.0);
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

  void _changeColor() {
    setState(() {
      // Change the color to a different one
      //print("mcs=$mcs");
      _containerColor1 = HSLColor.fromAHSL(1, mch, mcs, mcl).toColor();
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
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
        appBar: AppBar(
          title: const Text("ColorPicker"),
        ),
        drawer: Drawer(
          child: ListView(
            
            children: const [
              DrawerHeader(
                child: Center(
                  child: Text(
                    "ColorPicker help",
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
                  width:  canvaWidth,
                  height: canvaHeight,
                  
                  child: GestureDetector(
                   onTapDown: (TapDownDetails details) {
                      //print("Tapped the circle");
                      double x = details.localPosition.dx;
                      double y = details.localPosition.dy;
                      int index = (y * canvaWidth + x).toInt();
                      if (setMainColor) {
                        mch = getHue(x, y);
                        mcs = 2 * wheelR[index] / canvaWidth;
//                        print("R=${wheelR[index]}");
/*                        if (mcs < 0) {
//                        print("s unter 0");
                        } else if (mcs > 1) {
//                        print("s über 1");
                        }*/
                        mcl = lumi.toDouble() / 100.0;
                        //mainColor = HSLColor.fromAHSL(1, mch, mcs, mcl).toColor();
                        //mainColor = Colors.red;
                        _changeColor();
                        //_containerColor1 = Colors.red;
                      }
                    },
					
                        // You can add your sound logic here
          //                  print('x-Koordinate: ${details.localPosition.dx}');
          //                  print('y-Koordinate: ${details.localPosition.dy}');

      //},
                    child: CustomPaint(
                      painter: ColorPickerPainter(lumi),
                    ),
                  ),
                ),
              ),
              Text("Set light to $lumi %"),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 300),
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
        Container(
         child: Text("main color set to:")
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: _containerColor1,
            )
        ),
        Container(
         child: Text("secondary color set to:")
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: mainColor,
            )
        ),
            ],
          ),
        ),
      ),
    );
  }
}
