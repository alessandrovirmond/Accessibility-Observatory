
import 'dart:async';
import 'package:accessibility_audit/uitls/global_pages_utils/loading/global_page_loading.dart';
import 'package:accessibility_audit/uitls/graphs/controllers/my_line_chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';




class MyLineChart extends StatefulWidget {
  final int milliscond; // Add milliscond parameter

  const MyLineChart({Key? key, required this.milliscond}) : super(key: key); // Required parameter

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  late final MyLineChartController controller;

  @override
  void initState() {
    super.initState();
    controller = MyLineChartController(milliscond: widget.milliscond); 
    Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (mounted) {
        setState(() {
          // Update state if necessary
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: StreamBuilder<List>(
          stream: controller.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null || snapshot.connectionState == ConnectionState.waiting){
              return GlobalPageLoading();
            }
            return LineChart(controller.data); // Use controller.data
          },
        ),
      ),
    );
  }
}
