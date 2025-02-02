import 'package:flutter/material.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Trabalho de conclusão de curso"),
                            Text("CEFET - RJ"),
                            Text(
                                "UNIDADE DE ENSINO DESCENTRALIZADA DE NOVA FRIBURGO/RJ"),
                            Text("Professor Orientador: Nilson Lazarin"),
                            Text("Alunos:"),
                            Text("AlessandroVirmond\nGuilherme Resende"),
                          ],
                        );
  }
}