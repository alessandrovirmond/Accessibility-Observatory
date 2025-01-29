
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;


  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
 
  @override
  Widget build(BuildContext context) {
  
    return MouseRegion(
      
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
         
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.white :  Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal:30, vertical: 10),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 20),
              Text(
                widget.label,
                style: widget.isSelected
                    ? MyStyles.subtitleGridBlack
                    : MyStyles.titleGridWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}