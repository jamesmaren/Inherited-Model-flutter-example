import 'package:flutter/material.dart';
import 'dart:math' show Random;
import 'dart:developer' as devtools show log;

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //_HomePageState has to have var color1 and var color 2

  var color1 = Colors.yellow;
  var color2 = Colors.blue;

// This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: AvailableColorsWidget(
        color1: color1,
        color2: color2,
        child: Column(
          children: [
            Row(
              children: [
                //create two textbuttons each of which changes color and calls setstate
                TextButton(
                    onPressed: () {
                      setState(() {
                        color1 = colors.getRandomElement();
                      });
                    },
                    child: const Text("Change Color1")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        color2 = colors.getRandomElement();
                      });
                    },
                    child: const Text("Change Color2"))
              ],
            ),
            //add two colorWidget iNSTANCES
            const ColorWidget(
              color: AvailableColors.one,
            ),
            const ColorWidget(
              color: AvailableColors.two,
            ),
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two } //this is how it looks like

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorsWidget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  //Allow grabbing a copy
  //DEscendants need a way to grab a copy of this inheritedModel when being built

  static AvailableColorsWidget of(
      BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(context,
        aspect: aspect)!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    devtools.log('updateShouldNotify');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant AvailableColorsWidget oldWidget,
    Set<AvailableColors> dependencies,
  ) {
    devtools.log('updateShouldNotifyDependent');
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    return false;
  }
}

class ColorWidget extends StatelessWidget {
  //add AvailableColors to ColorWidget
  final AvailableColors color;

  const ColorWidget({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtools.log('Color1 widget got rebuilt');
        break;
      case AvailableColors.two:
        devtools.log('Color2 widget got rebuilt');
        break;
    }

    final provider = AvailableColorsWidget.of(
      context,
      color,
    );

    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}

final colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown,
  Colors.amber,
  Colors.deepPurple
];

//GRabbing random colors
extension RandomElement<T> on Iterable<T> {
  getRandomElement() => elementAt(
        Random().nextInt(length),
      );
}
