import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';

class OnHovered extends StatefulWidget {

  final Widget child;
  final String type;
  // ignore: prefer_typing_uninitialized_variables
  final size;


  // ignore: use_super_parameters
  const OnHovered({Key? key, required this.child, required this.type, this.size = 60 }) : super(key: key);
  @override
  State<OnHovered> createState() => _OnHoveredState();
}
class _OnHoveredState extends State<OnHovered> {

  bool isHovered = false;
  List<Color> colorHovered = [
    Colors.grey.withOpacity(0.1),
    Colors.grey.withOpacity(0.3),
    Colors.red.withOpacity(0.2),
  ];
  Color color = Colors.transparent;


  @override
  Widget build(BuildContext context) {
    final BoxDecoration styleHover = BoxDecoration(
      color: isHovered ? colorHovered[0] : color,
      border: Border.all(
        color: isHovered ? colorHovered[1] : color,
        width: 1.0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
    );
    
    final BoxDecoration styleHoverB = BoxDecoration(
      color: isHovered ? PalleteColor.red : color,
      border: Border.all(
        color: isHovered ? colorHovered[2] : color,
        width: 3.0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(25),
      ),
    );


    switch (widget.type) {
      case "icon":
        return MouseRegion(

            onEnter: (event) => onEntered(true),
            onExit: (event) => onEntered(false),

            child: Container(
                width: widget.size + 30,
                height: widget.size + 30,
                decoration: styleHover,
                child: widget.child
            )
        );

      case "start":
        final BoxDecoration startBoxHover = BoxDecoration(
          color: isHovered ? Colors.black12.withOpacity(0.2) : Colors
              .transparent,
          border: Border.all(
            color: isHovered ? Colors.black12.withOpacity(0.3) : Colors
                .transparent,
            width: 5.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
        );

        return MouseRegion(
          onEnter: (event) => onEntered(true),
          onExit: (event) => onEntered(false),
          child: Container(
            height: 40,
            width: 115,
            decoration: startBoxHover,
          ),
        );

      case "buttom":
        return MouseRegion(

            onEnter: (event) => onEntered(true),
            onExit: (event) => onEntered(false),

            child: Container(
                decoration: styleHoverB,
                child: widget.child
            )
        );

      case "selecter":
        return MouseRegion(

            onEnter: (event) => onEntered(true),
            onExit: (event) => onEntered(false),

            child: Container(
                decoration: styleHoverB,
                padding: const EdgeInsets.all(1),
                child: widget.child
            )
        );

      case "taskbar":
        return MouseRegion(

            onEnter: (event) => onEntered(true),
            onExit: (event) => onEntered(false),

            child: Container(
                decoration: styleHoverB,
                padding: const EdgeInsets.all(1),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    widget.child,
                  ],
                )
            )
        );

      default:
        return Container();
    }
  }

  void onEntered(isHovered) =>
      setState(() {
        this.isHovered = isHovered;
      });
}