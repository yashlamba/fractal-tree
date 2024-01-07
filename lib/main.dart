import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const FractalTreeApp());
}

class FractalTreeApp extends StatelessWidget {
  const FractalTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fractal Tree',
      theme: ThemeData(
        useMaterial3: true,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
      ),
      home: const FractalTree(),
    );
  }
}

class FractalTree extends StatefulWidget {
  const FractalTree({
    super.key,
  });

  @override
  State<FractalTree> createState() => _FractalTreeState();
}

class _FractalTreeState extends State<FractalTree> {
  double angle = 0;
  double decreaseFactor = 0.67;
  double initialLength = 100, finalLength = 5;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 500,
            width: MediaQuery.sizeOf(context).width.roundToDouble() - 20,
            child: CustomPaint(
              painter: FractalTreePainter(
                  angle: angle,
                  initialLength: initialLength,
                  finalLength: finalLength,
                  lengthDecay: decreaseFactor),
              child: Container(
              ),
            ),
          ),
          Container(
            width: min(MediaQuery.sizeOf(context).width - 40.0, 500),
            padding: const EdgeInsets.all(40.0),
            child: Column(children: [
              Slider(
                value: angle,
                onChanged: (double value) => setState(() {
                  angle = value;
                }),
                min: 0,
                max: 2 * pi,
                label: "$angle",
              ),
              const Text("Angle", style: TextStyle(color: Colors.white)),
              RangeSlider(
                values: RangeValues(finalLength, initialLength),
                onChanged: (RangeValues values) => setState(() {
                  initialLength = values.end.roundToDouble();
                  finalLength = values.start.roundToDouble();
                }),
                min: 1,
                max: 250,
                divisions: 249,
                labels: RangeLabels("$finalLength", "$initialLength"),
              ),
              const Text(
                "Min, Max length",
                style: TextStyle(color: Colors.white),
              ),
              Slider(
                value: decreaseFactor,
                onChanged: (double value) => setState(() {
                  decreaseFactor = value;
                }),
                min: 0.1,
                max: 0.7,
                label: "$decreaseFactor",
              ),
              const Text("Length Decay Factor", style: TextStyle(color: Colors.white)),
            ]),
          ), // This is for the controller class
        ],
      ),
    );
  }
}

class FractalTreePainter extends CustomPainter {
  double angle, initialLength, finalLength, lengthDecay;

  // Constructor
  FractalTreePainter(
      {required this.angle,
      required this.lengthDecay,
      required this.initialLength,
      required this.finalLength});
  // void generateFractalPath(Path tree, double length) {
  //   if (length < 10) return;
  //   double x = length * cos(pi / 6);
  //   double y = -length * sin(pi/6);
  //   tree.relativeLineTo(x, y);
  //   tree.relativeMoveTo(x, y);
  //   generateFractalPath(tree, length * 0.67);
  //   // tree.lineTo(200, 250);
  // }

  void generateFractalPath(Canvas canvas, Paint paint, double length) {
    if (length < finalLength) return;
    canvas.drawLine(Offset.zero, Offset(0, -length), paint);
    canvas.translate(0, -length);
    canvas.save();
    canvas.rotate(angle);
    generateFractalPath(canvas, paint, length * lengthDecay);
    canvas.restore();
    canvas.save();
    canvas.rotate(-angle);
    generateFractalPath(canvas, paint, length * lengthDecay);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    // var tree = Path();
    // tree.moveTo(250, 250);
    // generateFractalPath(tree, 100);
    canvas.translate(size.width / 2, 480);
    generateFractalPath(canvas, paint, initialLength);

    // tree.close();
    // canvas.drawPath(
    //   tree,
    //   paint
    // );
  }

  @override
  bool shouldRepaint(FractalTreePainter oldDelegate) => false;
}
