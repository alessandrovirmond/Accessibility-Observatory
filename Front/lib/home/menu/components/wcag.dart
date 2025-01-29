import 'package:flutter/material.dart';

class WCAG extends StatelessWidget {
  const WCAG({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("O que é?"),
        Text(
            "WCAG (Web Content Accessibility Guidelines) são diretrizes que garantem que os conteúdos digitais sejam acessíveis a pessoas com deficiência."),
        Text("Quais são os princípios?"),
        Text("Perceptível, Operável, Compreensível e Robusto (POUR)."),
        Text("Critérios básicos do 2.1 AA"),
        Text(
            "Incluem foco em acessibilidade móvel, navegação por teclado, contraste de cores, uso de textos alternativos e navegabilidade."),
      ],
    );
  }
}
