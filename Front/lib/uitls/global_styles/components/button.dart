import 'package:flutter/material.dart';


class ButtonRed extends StatefulWidget {

  final String text;
  final Function function;
  final double? width;
  final double? height;

  const ButtonRed({super.key, required this.text, required this.function, this.width, this.height});

  @override
  State<ButtonRed> createState() => _ButtonRedState();
}

class _ButtonRedState extends State<ButtonRed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(),
      child: Text(widget.text, textAlign: TextAlign.center,),
    );
  }
}
