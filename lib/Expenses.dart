import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  BarChartGroupData _createBarChartGroupData(int x) {
    return BarChartGroupData(
      x: x,

      barRods: [
        BarChartRodData(
          toY: 25,
          color: Colors.grey[800],
          width: 25,
          borderRadius: BorderRadius.zero,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 200,
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    // This function will build the bar chart
    // You can use a package like charts_flutter or fl_chart to create the chart
    return Container(
      height: 200, // ✅ Important!
      width: double.infinity, // 💡 This makes it take all horizontal space
      // margin: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 30),
      child: BarChart(
        BarChartData(
          barGroups: [
            _createBarChartGroupData(0),
            _createBarChartGroupData(1),
            _createBarChartGroupData(2),
            _createBarChartGroupData(3),
            _createBarChartGroupData(4),
            _createBarChartGroupData(5),
            _createBarChartGroupData(6),
          ],
          alignment: BarChartAlignment.spaceEvenly,
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              // 👈 You can keep bottom if needed
              sideTitles: SideTitles(
                showTitles: true,

                getTitlesWidget: (value, meta) {
                  const days = ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
                  if (value.toInt() < 0 || value.toInt() >= days.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(days[value.toInt()]);
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false), // ❌ Hide grid lines
          borderData: FlBorderData(show: false), // ❌ Hide chart borders
        ),
      ),
    );
  }

  Widget _buildButtonAddExpense() {
    return FloatingActionButton(
      onPressed: () {
        // Execute Modal Bottom Sheet
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 300, // 👈 custom width
                height: 250, // 👈 custom height
                padding: EdgeInsets.all(16),
              ),
            );
          },
        );
      },
      shape: CircleBorder(),
      backgroundColor: const Color.fromARGB(
        255,
        58,
        58,
        58,
      ), // optional: change color
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: Column(
        children: [
          _buildBarChart(),
          const SizedBox(height: 20),
          const Text(
            'here will be  Expenses',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      floatingActionButton: _buildButtonAddExpense(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
