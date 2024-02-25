import 'package:flutter/material.dart';
import 'dart:math'
    as math; // Importieren der Klasse Random aus der Standardbibliothek von Dart

var rng = math.Random(); // Erstellen einer neuen Instanz der Klasse Random

const Color primaryColor = Colors.blue;
const TargetPlatform platform = TargetPlatform.android;
const Color bgCol = Color.fromARGB(255, 210, 210, 210);
const Color bgColDarker = Color.fromARGB(255, 200, 200, 200);
double mch = 0.0, mcs = 0.0, mcl = 0.5; //main color hue etc.
double mch2 = 0.0, mcs2 = 0.0, mcl2 = 0.5; //main color hue etc.
Color mainColor = HSLColor.fromAHSL(1, mch, mcs, mcl).toColor();
Color secondColor = HSLColor.fromAHSL(1, mch2, mcs2, mcl2).toColor();
double canvaWidth = 370.0; //Abhängig vom Bildschirm machen
double canvaHeight = canvaWidth;
int numCanvaPoints = canvaWidth.toInt() * canvaHeight.toInt();

//  static const scaleFactor = 4;
//  static const tau = math.pi * 2;

double appBarHeight = 0;
double wantedRest = 100;
double screenWidth = 0;
double screenHeight = 0;
bool wheelCalculated = false;
double wheelTappedX = 0, wheelTappedY = 0;
bool setMainColor = true;

double minLumi = 0;
double lum = 50.0;

//const Color primaryColor = Colors.orange;
//const TargetPlatform platform = TargetPlatform.android;

//160.000 Punkte für das Farbrad ( bei 400*400)
List<int> wheelX = List<int>.filled(
    160000, 0); // Create a list of elements, all initialized to 0
List<int> wheelY = List<int>.filled(
    160000, 0); // Create a list of elements, all initialized to 0
List<double> wheelR = List<double>.filled(
    160000, 0.0); // Create a list of elements, all initialized to 0
List<double> wheelH = List<double>.filled(160000,
    -1.0); // Create a list of elements, all initialized to -1 (=nicht im Kreis)
const double radToDegree = 57.29577951308232;

void initColorWheel(double sizeX, double sizeY) {
  if (wheelCalculated) {
    return;
  }
  double centerX = sizeX / 2.0;
  double centerY = sizeY / 2.0;
  int i = 0;
  for (int y = 0; y < centerY.toInt(); y++) {
    //nur die Hälfte
    for (int x = 0; x <= centerX.toInt(); x++) {
      //nur die Hälfte, der Rest durch Symmetrien
      i = x + y * canvaWidth.toInt();
      wheelX[i] = x;
      wheelY[i] = y;
      double X = x.toDouble() - centerX;
      double Y = y.toDouble() - centerY;
      //print("i=$i ${x + y * canvaWidth.toInt()}");
      //if (i == 10000) print("vorher: i=10000 ${wheelX[10000]}");

      wheelR[i] = math.sqrt(X * X + Y * Y);
      if (wheelR[i] > centerY) {
        //zu groß
        wheelH[i] = -1; //markiert als außerhalb vom Kreis
      } else {
        //im Kreis, also Farbwinkel berechenbar
        if (wheelR[i] > canvaWidth / 2) {
          print("Alarm! $X $Y");
        }
        wheelH[i] = math.asin(Y.abs() / wheelR[i]) * radToDegree;
        //horizontale Symmetrie
        int xs = canvaWidth.toInt() - x;

        int j = xs + y * canvaWidth.toInt();
        wheelX[j] = xs;
        wheelY[j] = y;
        wheelR[j] = wheelR[i];

        wheelH[j] = 180 - wheelH[i];
        //vertikale Symmetrie
        int ys = canvaHeight.toInt() - y;

        int k = x + ys * canvaWidth.toInt();
        wheelX[k] = x;
        wheelY[k] = ys;
        wheelR[k] = wheelR[i];

        wheelH[k] = 360 - wheelH[i];
        //Punktsymmetrie

        ys = canvaHeight.toInt() - y;
        int l = xs + ys * canvaWidth.toInt();

        wheelX[l] = xs;
        wheelY[l] = ys;
        wheelR[l] = wheelR[i];

        wheelH[l] = wheelH[i] + 180;
      } // innerhalb des Kreises
    } //x-Schleife
  } //y-Schleife
}

double getHue(double x, double y) {
  int i = (x + canvaWidth * y).toInt();
  if (wheelH[i] > -1) {
    //recalc ist sicherer, warum?
    double centerX = canvaWidth / 2.0;
    double centerY = canvaWidth / 2.0;

    double dx = x - centerX;
    double dy = y - centerY;

    double radius = math.sqrt(dx * dx + dy * dy);
    if (radius > centerX) {
      print("außerhalb!");
    } else {
      print("radius=$radius");
    }

    //  print("testR=$testR");
    double Angle = math.asin(dy.abs() / radius) * radToDegree;
    if (dx > 0) {
      if dy> 0{
        //oben rechts
        Angle=180-Angle;
        work here
      }
    }

    //print("Angle=$Angle wheelH[i]=${wheelH[i]}");

//    print("i=$i x=$x -> ${wheelX[i]}");
//  print("y=$y -> ${wheelY[i]}");
    return wheelH[i];
  } else {
    return 0.0;
  }
}
