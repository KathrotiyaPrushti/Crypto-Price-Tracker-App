import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final List<Map<String, dynamic>> historicalData;

  PriceChart({required this.historicalData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: historicalData.map((data) {
              return FlSpot(
                (data['time'] as int).toDouble(),
                (data['price'] as double),
              );
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
