import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyTextBox extends StatelessWidget {
  const MyTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(title: Text("example")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SentientTextField(
          cornerRadius: 90,
          indentHeight: 20,
          indentCornerRadius: 12,
          indentWidth: 52,
          size: Size(600, 90),
          textBoxColor: Color(0xff4059AD),
          backgroundColor: Color(0xff6b9ac4),
          controller: TextEditingController(),
          label: "Name",
          hint: "Enter Your Name",
          textColor: Colors.black,
          hintColor: Colors.black,
          labelColor: Colors.black,
          labelFontSize: 17,
        ),
      ),
    );
  }
}

class SentientTextField extends StatefulWidget {
  final TextEditingController controller;

  final double cornerRadius;
  final double indentHeight;
  final double indentCornerRadius;
  final double indentWidth;
  final double labelFontSize;
  final Size size;

  final Color textBoxColor;
  final Color backgroundColor;

  final Color textColor;
  final Color hintColor;
  final Color labelColor;

  final String label;
  final String hint;

  const SentientTextField({
    super.key,
    required this.cornerRadius,
    required this.indentHeight,
    required this.indentCornerRadius,
    required this.indentWidth,
    required this.size,
    required this.textBoxColor,
    required this.backgroundColor,
    required this.controller,
    required this.textColor,
    required this.hintColor,
    required this.labelColor,
    required this.label,
    required this.hint,
    required this.labelFontSize,
  });

  @override
  State<SentientTextField> createState() => _SentientTextFieldState();
}

class _SentientTextFieldState extends State<SentientTextField> with SingleTickerProviderStateMixin {
  final GlobalKey mKey = GlobalKey();

  Size? widgetSize;

  double increaseHeight = 0;

  late AnimationController _animationController;
  //late Animation<double> _animation;
  late Animation _animatedIndentHeightTextBox;
  bool isSelected = false;

  void textBoxEngade(bool val) {
    setState(() {
      if (val) {
        _animationController.reverse();
        isSelected = false;
      } else {
        _animationController.forward();
        isSelected = true;
      }
    });
  }

  @override
  void initState() {
    // ANIMATION
    _animationController = AnimationController(duration: Duration(milliseconds: 450), vsync: this);

    // _animation = Tween<double>(begin: 0, end: widget.indentHeight).animate(_animationController);

    _animatedIndentHeightTextBox = Tween<double>(begin: 0, end: widget.indentHeight + increaseHeight).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          constraints: BoxConstraints(minHeight: widget.size.height + widget.indentHeight + increaseHeight, minWidth: 200),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: (widget.cornerRadius / 2) + (widget.indentCornerRadius * 2) + 14),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: isSelected ? 1 : 0,
                  child: Text(
                    widget.label,
                    style: TextStyle(fontSize: widget.labelFontSize, fontWeight: FontWeight.bold, color: widget.labelColor),
                  ),
                ),
              ),

              CustomPaint(
                size: Size(widget.size.width, widget.size.height + _animatedIndentHeightTextBox.value + increaseHeight),
                painter: TextBoxPainter(
                  widget.cornerRadius,
                  14,
                  widget.indentWidth,
                  (_animatedIndentHeightTextBox.value),
                  12,
                  widget.indentCornerRadius,
                  widget.backgroundColor,
                  widget.controller.text,
                  TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: widget.textColor),
                ),
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                top: isSelected ? widget.indentHeight + 8 : 8,
                left: 8,
                curve: Curves.bounceInOut,
                child: _STextField(
                  controller: widget.controller,
                  textColor: widget.textColor,
                  textBoxColor: widget.textBoxColor,
                  width: widget.size.width - 16,
                  minHeight: widget.size.height - 16,
                  hint: widget.hint,
                  hintColor: widget.hintColor,
                  onChanged: (value) {
                    setState(() {
                      textBoxEngade(widget.controller.text.isEmpty);
                    });
                  },
                  onExapaned: (height) {
                    setState(() {
                      increaseHeight = height - (widget.size.height - 16);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _STextField extends StatefulWidget {
  const _STextField({
    super.key,
    required this.controller,
    required this.textColor,
    required this.textBoxColor,
    required this.width,
    required this.hint,
    required this.hintColor,
    required this.onChanged,
    required this.onExapaned,
    required this.minHeight,
  });

  final TextEditingController controller;
  final Color textColor;
  final Color textBoxColor;
  final double width;
  final double minHeight;
  final String hint;
  final Color hintColor;

  final void Function(String) onChanged;
  final void Function(double) onExapaned;

  @override
  State<_STextField> createState() => __STextFieldState();
}

class __STextFieldState extends State<_STextField> {
  double renderHeight = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: widget.minHeight),
      width: widget.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: widget.textBoxColor),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: TextField(
            minLines: 1,
            maxLines: null,
            controller: widget.controller,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: widget.textColor),
            onChanged: (value) {
              widget.onChanged(value);
              widget.onExapaned(context.size?.height ?? 0);
            },

            decoration: InputDecoration(
              border: InputBorder.none,
              hint: Text(
                widget.hint,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: widget.hintColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// PAINTER

class TextBoxPainter extends CustomPainter {
  double cornerRadius = 0;
  double indentSpaceFromStart = 0;
  double indentWidth = 0;
  double indentHeight = 0;
  double indentCornerSize = 0;
  double indentCornerRadius = 0;
  Color color = Colors.deepPurple;
  String? text;
  TextStyle? style;

  TextBoxPainter(
    double cornerRadius_p,
    double indentSpaceFromStart_p,
    double indentWidth_p,
    double indentHeight_p,
    double indentCornerSize_p,
    double indentCornerRadius_p,
    Color col,
    String? text_p,
    TextStyle? style_p,
  ) {
    cornerRadius = cornerRadius_p;
    indentSpaceFromStart = indentSpaceFromStart_p;
    indentWidth = indentWidth_p;
    indentHeight = indentHeight_p;
    indentCornerSize = indentCornerSize_p;
    indentCornerRadius = indentCornerRadius_p;
    color = col;
    text = text_p;
    style = style_p;
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
  path.arcTo(Rect.fromPoints(Offset(size.width - cornerRadius, 0), Offset(size.width, cornerRadius)), -(math.pi / 2), math.pi / 2, false);

  path.arcTo(Rect.fromPoints(Offset(size.width - cornerRadius, size.height - cornerRadius), Offset(size.width, size.height)), math.pi * 2, math.pi / 2, false);

  path.lineTo(cornerRadius / 2, size.height);

  path.arcTo(Rect.fromPoints(Offset(0, size.height - cornerRadius), Offset(cornerRadius, size.height)), math.pi / 2, math.pi / 2, false);

  path.arcTo(Rect.fromPoints(Offset.zero, Offset(cornerRadius, cornerRadius)), math.pi, math.pi / 2, false);

  path.close();

  return path;
}
