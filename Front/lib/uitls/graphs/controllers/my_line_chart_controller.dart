
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/models/line_chart_model.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/repository/line_chart_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MyLineChartController{

  final BehaviorSubject<List<LineChartModel>> _bloc = BehaviorSubject();
  final LineChartRepository _repository = LineChartRepository();
  final int ocup = 200;
  
  final int milliscond;
  Stream<List<LineChartModel>> get stream => _bloc.stream;
  
  
  MyLineChartController({required this.milliscond}){
    _bloc.sink.add([]);
    _bloc.interval(const Duration(seconds: 5)).listen((e)async{
        _bloc.sink.add((await _repository.getLineChart(millisecond: milliscond)));
    });
    _bloc.stream.listen((data){
      enter = data.map((e)=> e.toFlEnter()).toList();
      out = data.map((e)=>e.toFlOut()).toList();
    });
  }


   List<FlSpot> enter = [
    const FlSpot(6, 0),
    const FlSpot(8, 0),
    const FlSpot(10, 0),
    const FlSpot(12, 0),
    const FlSpot(14, 0),
    const FlSpot(16, 0),
    const FlSpot(18, 0),
    const FlSpot(20, 0),
    const FlSpot(22, 0),
    const FlSpot(24, 0),
  ];
  List<FlSpot> out = [
    const FlSpot(6, 0),
    const FlSpot(8, 0),
    const FlSpot(10, 0),
    const FlSpot(12, 0),
    const FlSpot(14, 0),
    const FlSpot(16, 0),
    const FlSpot(18, 0),
    const FlSpot(20, 0),
    const FlSpot(22, 0),
    const FlSpot(24, 0),
  ];
 ////////////////////////////////////////////////////////////////////////////////////////// 
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
   LineChartData get data => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 6,
    maxX: 24,
    maxY: ocup.toDouble(),
    minY: 0,
  );

  LineTouchData get lineTouchData1 => const LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
  ];

  LineTouchData get lineTouchData2 => const LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    if(value.toInt() == _controllerInit(10,ocup) ){
      text = _controllerInit(10,ocup).toString();
    }
    else if (value.toInt() == _controllerInit(20,ocup) ){
      text = _controllerInit(20,ocup).toString();
    }
    else if (value.toInt() == _controllerInit(30,ocup) ){
      text = _controllerInit(30,ocup).toString();
    }
    else if (value.toInt() == _controllerInit(40,ocup) ){
      text = _controllerInit(40,ocup).toString();
    }
    else if (value.toInt() == _controllerInit(50,ocup) ){
      text = _controllerInit(50,ocup).toString();
    }
    else if (value.toInt() == _controllerInit(60,ocup) ){
      text = _controllerInit(60,ocup).toString();
    }
    else if (value.toInt() == _controllerInit(70,ocup) ){
      text = _controllerInit(70,ocup).toString();
    }
    else if (value.toInt() == _controllerInit(80,ocup) ){
      text = _controllerInit(80,ocup).toString();
    }
    else if (value.toInt() == _controllerInit(90,ocup) ){
      text = _controllerInit(90,ocup).toString();
    }

    else{
      text = "";
    }
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 6:
        text = const Text('6H', style: style);
        break;
      case 8:
        text = const Text('8H', style: style);
        break;
      case 10:
        text = const Text('10H', style: style);
        break;
      case 12:
        text = const Text('12H', style: style);
        break;
      case 14:
        text = const Text('14H', style: style);
        break;
      case 16:
        text = const Text('16H', style: style);
        break;
      case 18:
        text = const Text('18H', style: style);
        break;
      case 20:
        text = const Text('20H', style: style);
        break;
      case 22:
        text = const Text('22H', style: style);
        break;
      case 24:
        text = const Text('24H', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 4),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Colors.black,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: enter
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: PalleteColor.red,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
      color: Colors.black,
    ),
    spots: out
  );


  
_controllerInit(int person,int ocup) {

    int result = ocup * person;
    result = result~/100;

    return result;
  }




}