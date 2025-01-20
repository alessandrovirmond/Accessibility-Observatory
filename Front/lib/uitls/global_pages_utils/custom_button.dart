// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Widget child;
  final String tooltipText;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.child,
    required this.tooltipText,
    required this.onPressed,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
          });
        },
        onExit: (_) {
          setState(() {
          });
        },
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: widget.tooltipText,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
