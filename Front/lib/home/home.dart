import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/home/menu/menu.dart';
import 'package:accessibility_audit/home/enum/enum_home.dart';
import 'package:accessibility_audit/home/home_page/home_page..dart';
import 'package:accessibility_audit/report/page/report_page.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static late BuildContext homeContext;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

    void _reloadHome() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  
                  child: Text(
                  "Observatório de Acessibilidade de Portais Municipais",
                    style: MyStyles.titleGrid,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                color: PalleteColor.blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    height: 44,
                    child: Menu(onUpdate: _reloadHome,)
                  ),
                  Expanded(child: Config.enumHome == EnumHome.home ? HomePage(onUpdate: _reloadHome) : ReportPage()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
