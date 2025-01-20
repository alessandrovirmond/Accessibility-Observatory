import 'package:fl_chart/fl_chart.dart';

class LineChartModel {
  final int timer;
  final int enter;
  final int out;

  LineChartModel({required this.timer, required this.enter, required this.out});

  FlSpot toFlEnter() => FlSpot(timer.toDouble(), enter.toDouble());
  FlSpot toFlOut() => FlSpot(timer.toDouble(), out.toDouble());

  factory LineChartModel.fromJson(Map<String, dynamic> json) => LineChartModel(
      timer: json["timer"], enter: json["enter"], out: json["out"]);
}
