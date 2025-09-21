import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/election_result_controller.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';

class ElectionResultView extends StatelessWidget {
  final ElectionResultController controller =
      Get.put(ElectionResultController());

  ElectionResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Election Results"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.fetchElectionResults,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3DA09D),
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.results.isEmpty) {
          return const Center(
            child: Text(
              "No results available.",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: _buildElectionResultsCard(),
            ),
            const CustomNavBar(activePage: '/stats'),
          ],
        );
      }),
    );
  }

  Widget _buildElectionResultsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.bar_chart, size: 28, color: Color(0xFF35444F)),
                const SizedBox(width: 10),
                Text(
                  controller.electionName.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF35444F),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: controller.totalVotes.value.toDouble() + 5,
                  barGroups: _generateBarGroups(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.black,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          "${controller.results[group.x].name}\nVotes: ${rod.toY.toInt()}",
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    drawHorizontalLine: true,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: _leftTitles,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: _bottomTitles,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Total Votes: ${controller.totalVotes.value}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF35444F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return controller.results
        .asMap()
        .entries
        .map(
          (entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.voteCount.toDouble(),
                color: const Color(0xFF3DA09D),
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        )
        .toList();
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final titles = controller.results.map((c) => c.name).toList();
    if (value.toInt() < 0 || value.toInt() >= titles.length) {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        titles[value.toInt()],
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    if (value % 5 == 0) {
      return Text(
        value.toInt().toString(),
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      );
    }
    return Container();
  }
}
