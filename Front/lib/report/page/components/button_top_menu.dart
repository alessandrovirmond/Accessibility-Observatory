import 'package:accessibility_audit/report/page/components/button_top_menu_model.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';

class ButtonTopMenu extends StatefulWidget {
  final ButtonTopMenuModel tile;

  const ButtonTopMenu({super.key, required this.tile});

  @override
  State<ButtonTopMenu> createState() => _ButtonTopMenuState();
}

class _ButtonTopMenuState extends State<ButtonTopMenu> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (action) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (action) {
        setState(() {
          isHover = false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.tile.onTap,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: PalleteColor.blue),
            color: isHover ? Colors.grey.shade400 : Colors.white,
          ),
          alignment: Alignment.center,
         
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.tile.icon,
                color: isHover ? Colors.white : Colors.black,
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}
