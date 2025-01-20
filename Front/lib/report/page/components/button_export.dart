import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExportButton extends StatefulWidget {
  final Function exportCsv;
  final Function exportPdf;
  final Function exportExcel;

  const ExportButton({
    Key? key,
    required this.exportCsv,
    required this.exportPdf,
    required this.exportExcel,
  }) : super(key: key);

  @override
  State<ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton> {
  bool isHovered = false; 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(16), 
        onTap: () {
          _showDropdown(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey.shade400 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Icon(Icons.download, color: isHovered ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  void _showDropdown(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 'csv',
          child: Row(
            children: const [
              Icon(FontAwesomeIcons.fileCsv, color: Colors.blue),
              SizedBox(width: 10),
              Text('Exportar como CSV'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'excel',
          child: Row(
            children: const [
              Icon(FontAwesomeIcons.fileExcel, color: Colors.green),
              SizedBox(width: 10),
              Text('Exportar como Excel'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: const [
              Icon(FontAwesomeIcons.filePdf, color: Colors.red),
              SizedBox(width: 10),
              Text('Exportar como PDF'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'csv':
            widget.exportCsv();
            break;
          case 'excel':
            widget.exportExcel();
            break;
          case 'pdf':
            widget.exportPdf();
            break;
          default:
            break;
        }
      }
    });
  }
}
