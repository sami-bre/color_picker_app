/* 
Color_picker_app
Programmed by Samuel Birhanu
*/

import 'dart:math';
import 'package:flutter/material.dart';

Random random = Random();
double startHue = random.nextDouble() * 360;
double startSaturation = random.nextDouble();
double startLightness = random.nextDouble();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MaterialColor primarySwatch;
  // the following two variables are here not for good reason. they're only used around the top of the build function
  String primarySwatchString = "";
  int ind = 0;
  double hue = startHue;
  double saturation = startSaturation;
  double lightness = startLightness;
  String colorHexCode = "";

  @override
  Widget build(BuildContext context) {
    primarySwatch = createMaterialColor(
        HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor());
    primarySwatchString = primarySwatch.toString();
    ind = primarySwatchString.indexOf("(0x");
    colorHexCode = primarySwatch.toString().substring(ind + 3, ind + 11);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: buildContents(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContents() {
    Widget what_to_return;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      what_to_return = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildColorPad(),
          SizedBox(height: 15.0),
          buildOutputText(),
          SizedBox(height: 15.0),
          buildHueSlider(),
          SizedBox(height: 15.0),
          buildSaturationSlider(),
          SizedBox(height: 15.0),
          buildLightnessSlider(),
        ],
      );
    } else {
      what_to_return = Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildColorPad(),
                SizedBox(height: 15.0),
                buildOutputText(),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildHueSlider(),
                SizedBox(height: 15.0),
                buildSaturationSlider(),
                SizedBox(height: 15.0),
                buildLightnessSlider(),
              ],
            ),
          )
        ],
      );
    }

    return what_to_return;
  }

  Widget buildColorPad() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
          color: primarySwatch,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }

  Widget buildOutputText() {
    return Text(
      colorHexCode,
      style: Theme.of(context).textTheme.headline4,
    );
  }

  Widget buildHueSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Hue",
          textAlign: TextAlign.left,
        ),
        Slider(
          min: 0.0,
          max: 360.0,
          value: hue,
          onChanged: handleHueChange,
        ),
      ],
    );
  }

  Widget buildSaturationSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Saturation",
          textAlign: TextAlign.left,
        ),
        Slider(
          min: 0.0,
          max: 1.0,
          value: saturation,
          onChanged: handleSaturationChange,
        ),
      ],
    );
  }

  Widget buildLightnessSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Lightness",
          textAlign: TextAlign.left,
        ),
        Slider(
          min: 0.0,
          max: 1.0,
          value: lightness,
          onChanged: handleLightnessChange,
        ),
      ],
    );
  }

  void handleHueChange(double newValue) {
    setState(() {
      hue = newValue;
      // primarySwatch = createMaterialColor(
      //   HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor(),
      // );
    });
  }

  void handleSaturationChange(double newValue) {
    setState(() {
      saturation = newValue;
      // primarySwatch = createMaterialColor(
      //   HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor(),
      // );
    });
  }

  void handleLightnessChange(double newValue) {
    setState(() {
      lightness = newValue;
      // primarySwatch = createMaterialColor(
      //   HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor(),
      // );
    });
  }
}

// code from https://medium.com/@filipvk/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
// credits go there.
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
