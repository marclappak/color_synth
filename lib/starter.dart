import 'package:flutter/material.dart';
import 'prerun.dart';

class Starter extends StatelessWidget {
  const Starter({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

Padding myPaddingElement(int index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/images/image$index.png"),
              fit: BoxFit.cover,
            ))),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
      return Container(
        color: bgColDarker,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
//            Row(Text("Die Bilder sind noch Platzhalter")),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Die Bilder sind noch Platzhalter:",
                style: TextStyle(fontSize: 19),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                myPaddingElement(1),
                myPaddingElement(2),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                myPaddingElement(3),
                myPaddingElement(4),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                myPaddingElement(5),
                myPaddingElement(6),
              ],
            ),
          ],
        ),
      );
    //);
  }
}
