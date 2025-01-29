import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StreakChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 3.0, // Adjust aspect ratio for better fitting
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false), // Hide grid lines
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide left Y-axis titles
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide bottom X-axis titles
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide bottom X-axis titles
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 1,  // Ensures all labels are shown
                  getTitlesWidget: (double value, TitleMeta meta) {
                    switch (value.toInt()) {
                      case 1:
                        return Text("1D", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
                      case 60:
                        return Text("1W", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
                      case 90:
                        return Text("1M", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
                      case 180:
                        return Text("3M", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
                      case 365:
                        return Text("1Y", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
                      default:
                        return Container();
                    }
                  },
                ),
              ),

            ),
            borderData: FlBorderData(
              show: false, // Hide border lines
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(1, 2),
                  FlSpot(7, 4),
                  FlSpot(15, 3),
                  FlSpot(30, 6),
                  FlSpot(60, 5),
                  FlSpot(90, 8),
                  FlSpot(180, 7),
                  FlSpot(365, 10),

                ],
                isCurved: true, // Smooth line
                color: Colors.pink.shade800, // Match UI color
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                  show: false,
                ),
                dotData: FlDotData(show: false), // Hide dots
              ),
            ],
          ),
        ),
      ),
    );
  }
}
