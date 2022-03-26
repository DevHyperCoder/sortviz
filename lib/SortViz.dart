import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SortViz extends StatelessWidget {
  final List<int> array;
  SortViz({required this.array});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(minWidth: double.infinity, minHeight: double.infinity),
      child: CustomPaint(
        painter: _SortVizPainter(array: array),
      ),
    );
  }
}

class _SortVizPainter extends CustomPainter {
  List<int> array;
  _SortVizPainter({required this.array});

  @override
  void paint(Canvas canvas, Size size) {
    final box = Rect.fromLTRB(0, 0, size.width, size.height);
    final paint = Paint();
    paint.color = Color.fromARGB(255, 240, 240, 253);
    canvas.drawRect(box, paint);

    paint.color = Colors.lightGreenAccent;
    //ui.Gradient.radial(c, radius, colors)
    paint.shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2), size.width / 0.75, [
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
    ], [
      0.0,
      0.75
    ]);

    final lineWidth = (size.width) / array.length;
    final unitH = size.height / 100;
    double prev = 0;

    array.forEach((element) {
      final e = Rect.fromLTRB(
          prev, size.height - (element * unitH), prev + lineWidth, size.height);
      canvas.drawRect(e, paint);
      prev += lineWidth;
    });
  }

  @override
  bool shouldRepaint(_SortVizPainter oldDelegate) {
    return false;
  }
}
