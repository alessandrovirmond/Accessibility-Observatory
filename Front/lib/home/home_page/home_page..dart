import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/home/enum/enum_home.dart';
import 'package:accessibility_audit/home/home_page/graph_home/home_chart.dart';
import 'package:accessibility_audit/home/home_page/info_home.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
    final Function() onUpdate;
  const HomePage({super.key,  required this.onUpdate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Row(
      children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: HomeChart(updateWindows: false)),
            )),
        Expanded(  
            flex: 1,
            child:InfoHome(onUpdate: widget.onUpdate))
      ],
    )),
        
      ],
    );
  }
}
