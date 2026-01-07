import 'package:flutter/material.dart';
import 'dart:math' as math;

class TextBoxPainter extends CustomPainter {
  double cornerRadius = 0;
  double indentSpaceFromStart = 0;
  double indentWidth = 0;
  double indentHeight = 0;
  double indentCornerSize = 0;
  double indentCornerRadius = 0;
  Color color = Colors.deepPurple;

  TextBoxPainter(double cornerRadius_p, double indentSpaceFromStart_p, double indentWidth_p, double indentHeight_p, double indentCornerSize_p, double indentCornerRadius_p, Color col) {
    cornerRadius = cornerRadius_p;
    indentSpaceFromStart = indentSpaceFromStart_p;
    indentWidth = indentWidth_p;
    indentHeight = indentHeight_p;
    indentCornerSize = indentCornerSize_p;
    indentCornerRadius = indentCornerRadius_p;
    color = col;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 4;
    paint.color = color;

    Path path = TextBoxPath(size, cornerRadius, indentSpaceFromStart, indentWidth, indentHeight, indentCornerRadius, indentCornerSize);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

Path TextBoxPath(Size size, double cornerRadius, double _indentSpaceFromStart, double indentWidth, double indentHeight, double indentCornerRadius, double indentCornerSize) {
  var path = Path();

  var indentSpaceFromStart = (cornerRadius / 2) + _indentSpaceFromStart;

  path.moveTo(cornerRadius / 2, 0);

  // Top Start ARC
  // path.arcTo(Rect.fromPoints(Offset.zero, Offset(cornerRadius, cornerRadius)), math.pi / 2, math.pi, false);

  path.lineTo(indentSpaceFromStart, 0);

  path.cubicTo(
    indentSpaceFromStart + indentCornerRadius,
    0,
    (indentSpaceFromStart + (indentCornerSize * 2)) - indentCornerRadius,
    indentHeight,
    indentSpaceFromStart + (indentCornerSize * 2),
    indentHeight,
  );

  path.lineTo(indentWidth + indentSpaceFromStart + (indentCornerSize * 2), indentHeight);

  path.cubicTo(
    indentSpaceFromStart + (indentCornerSize * 2) + indentWidth + indentCornerRadius,
    indentHeight,
    (indentSpaceFromStart + indentWidth + (indentCornerSize * 4)) - indentCornerRadius,
    0,
    indentSpaceFromStart + (indentCornerSize * 4) + indentWidth,
    0,
  );

  path.lineTo(size.width - cornerRadius / 2, 0);

  // // Top End Arc
  path.arcTo(Rect.fromPoints(Offset(size.width - cornerRadius, 0), Offset(size.width, size.height)), -(math.pi / 2), math.pi, false);

  path.lineTo(cornerRadius / 2, size.height);

  path.arcTo(Rect.fromPoints(Offset.zero, Offset(cornerRadius, size.height)), math.pi / 2, math.pi, false);

  path.close();

  return path;
}
