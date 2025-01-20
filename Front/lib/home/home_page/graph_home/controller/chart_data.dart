class ChartData {
  final String name;
  final double value;

  ChartData(
    this.name,
    this.value,
  );
}

List<ChartData> createChartData(Map<String, double>? dataMap) {
  List<ChartData> chartDataList = [];

  if (dataMap != null) {
    dataMap.forEach((category, value) {
      ChartData chartData = ChartData(category, value);
      chartDataList.add(chartData);
    });
  }

  return chartDataList;
}
