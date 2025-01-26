import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/home/enum/enum_home.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:accessibility_audit/report/repository/domain_repository.dart';
import 'package:flutter/material.dart';

class InfoHome extends StatefulWidget {
  final Function() onUpdate;
  const InfoHome({super.key, required this.onUpdate});

  @override
  State<InfoHome> createState() => _InfoHomeState();
}

class _InfoHomeState extends State<InfoHome> {
  final DomainRepository domainRepository = DomainRepository();
  int domainCount = 0;

  @override
  void initState() {
    super.initState();
    _getDomainCount();
  }

  // Função para obter a quantidade de domínios
  _getDomainCount() async {
    int count = await domainRepository.getDomainCount();
    setState(() {
      domainCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título Principal • centralizado
            Center(
              child: Text(
                "Monitoramento da acessibilidade",
                style: MyStyles.subBoldBlack,
              ),
            ),
            const SizedBox(height: 16),

            // Informações com número dinâmico
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " • $domainCount Sites de prefeitura avaliados",
                    style: MyStyles.bodyTextLarge, // Aplicando estilo maior
                  ),
                  const SizedBox(height: 8),
                  Text(
                    " • Avaliação de Acessibilidade de acordo com as normas do WCAG 2.0",
                    style: MyStyles.bodyTextLarge, // Aplicando estilo maior
                  ),
                  const SizedBox(height: 8),
                  Text(
                    " • Nota de acessibilidade considerando grau de impacto das violações no site",
                    style: MyStyles.bodyTextLarge, // Aplicando estilo maior
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Relatórios detalhados • centralizado
            Center(
              child: Text(
                "Relatórios detalhados",
                style: MyStyles.subBoldBlack,
              ),
            ),
            const SizedBox(height: 8),

            // Detalhes sobre os relatórios
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  " • Páginas do portal municipal",
                  style: MyStyles.bodyTextLarge, // Aplicando estilo maior
                ),
                Text(
                  " • Violações de acessibilidade em cada página",
                  style: MyStyles.bodyTextLarge, // Aplicando estilo maior
                ),
                Text(
                  " • Elementos envolvidos em violações",
                  style: MyStyles.bodyTextLarge, // Aplicando estilo maior
                ),
                Text(
                  " • Filtros e gráficos personalizados",
                  style: MyStyles.bodyTextLarge, // Aplicando estilo maior
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botão "Ver Relatório" • centralizado
            Center(
              child: GestureDetector(
                onTap: () {
                  Config.enumHome = EnumHome.report;
                  widget.onUpdate();
                },
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "Ver Relatório",
                      style: MyStyles.subBoldwhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
