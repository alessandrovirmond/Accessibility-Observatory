import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/home/enum/enum_home.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final Function() onUpdate;

  const Menu({super.key, required this.onUpdate});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
     
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botão Home
                MenuButton(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: Config.enumHome == EnumHome.home,
                  onTap: () {
                    setState(() {
                      Config.enumHome = EnumHome.home;
                      widget.onUpdate();
                    });
                  },
                ),
      
                // Botão Relatório
                MenuButton(
                  icon: Icons.list,
                  label: 'Relatório',
                  isSelected: Config.enumHome == EnumHome.report,
                  onTap: () {
                    setState(() {
                      Config.enumHome = EnumHome.report;
                      widget.onUpdate();
                    });
                  },
                ),
                MenuButton(
                  icon: Icons.info,
                  label: 'Sobre',
                  isSelected: Config.enumHome == EnumHome.sobre,
                  onTap: () {
                     showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sobre'),
                          content: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Text("Trabalho de conclusão de curso"),
                            Text("CEFET - RJ"),
                            Text("UNIDADE DE ENSINO DESCENTRALIZADA DE NOVA FRIBURGO/RJ"),
                            Text("Professor Orientador: Nilson Lazarin"),
                            Text("Alunos:"),
                            Text("AlessandroVirmond\nGuilherme Resende"),
                          ],),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Última atualização em: 20/01/2025",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
         
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal:70, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 20),
              Text(
                label,
                style: isSelected
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
