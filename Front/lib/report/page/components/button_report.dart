import 'package:accessibility_audit/report/controller/domain_contoller.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';
import 'package:accessibility_audit/report/page/components/button_data.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';

class ButtonReport extends StatefulWidget {
  final ButtonData data;
  final Function() callback;

  const ButtonReport({
    Key? key,
    required this.data,
    required this.callback,
  }) : super(key: key);

  @override
  _ButtonReportState createState() => _ButtonReportState();
}

class _ButtonReportState extends State<ButtonReport> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.callback,
          child: IntrinsicWidth( // Permite ajustar o tamanho com base no conteúdo
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 350, // Limita a largura máxima do botão
                minHeight: 40, // Altura mínima
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(5, 5),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  widget.data.label,
                  maxLines: 1, // Garante que o texto tenha no máximo 1 linha
                  overflow: TextOverflow.ellipsis, // Adiciona o "..." no final, se necessário
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
