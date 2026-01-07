import 'package:flutter/material.dart';
import 'package:textboxproj/boxPainter.dart';

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
          size: Size(400, 90),
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

    _animatedIndentHeightTextBox = Tween<double>(begin: 0, end: widget.indentHeight).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut));

    // setState(() {
    //   if (widget.controller.text.isEmpty) {
    //     indentHeight = 0;
    //   } else {
    //     indentHeight = widget.indentHeight;
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          constraints: BoxConstraints(minHeight: widget.size.height + widget.indentHeight),
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
                size: Size(widget.size.width, widget.size.height + _animatedIndentHeightTextBox.value),
                painter: TextBoxPainter(widget.cornerRadius, 14, widget.indentWidth, (_animatedIndentHeightTextBox.value), 12, widget.indentCornerRadius, widget.backgroundColor),
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                top: isSelected ? widget.indentHeight + 8 : 8,
                left: 8,
                curve: Curves.bounceInOut,
                child: Container(
                  height: widget.size.height - 16,
                  width: widget.size.width - 16,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: widget.textBoxColor),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: widget.controller,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: widget.textColor),
                        onChanged: (value) {
                          setState(() {
                            textBoxEngade(widget.controller.text.isEmpty);
                          });
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
