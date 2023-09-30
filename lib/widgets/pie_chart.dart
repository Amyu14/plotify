import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';

class PieChartWidget extends StatelessWidget {
  final Chart chart;
  const PieChartWidget(this.chart, {super.key});

  @override
  Widget build(BuildContext context) {
    final PieChartOptions options = chart.options as PieChartOptions;
    double valSum = 0;
    for (double val in chart.data) {
      valSum += val;
    }

    return PieChart(PieChartData(
      
        centerSpaceRadius: options.centerDistance,
        sectionsSpace: options.sectionsSpacing,
        startDegreeOffset: options.offsetAngle,
        sections: [
          for (int i = 0; i < chart.data.length; i++)
            PieChartSectionData(
                radius: options.sectionWidths[i],
                value: chart.data[i],
                color: Color(options.sectionColors[i]),
                title: options.showFreq && options.includeFreqInLabels
                    ? options.showLabels ? (options.showAsPct
                        ? (valSum == 0 ? "" : "${(chart.data[i] / valSum * 100).round()}%")
                        : "${options.sectionNames[i]} (${chart.data[i]})") : options.showAsPct ?
                       (valSum == 0 ? "" : "${(chart.data[i] / valSum * 100).round()}%")
                        : "${chart.data[i]}"
                    : options.showLabels ? options.sectionNames[i] : "",
                titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Color(options.labelColors[i]),
                    fontSize: options.labelFontSizes[i],
                    fontWeight: options.labelFontWeights[i] == 0 ? FontWeight.normal : FontWeight.bold),
                titlePositionPercentageOffset: options.labelOffsets[i] / 100,
                badgeWidget: options.showFreq && !options.includeFreqInLabels
                    ? options.showAsPct ? 
                    Text(
                        (valSum == 0 ? "" : "${(chart.data[i] / valSum * 100).round()}%"),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Color(options.freqColors[i]),
                            fontSize: options.freqFontSizes[i],
                            fontWeight: options.labelFontWeights[i] == 0 ? FontWeight.normal : FontWeight.bold),
                      )
                    : Text(
                        chart.data[i].toString(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Color(options.freqColors[i]),
                            fontSize: options.freqFontSizes[i],
                            fontWeight: options.labelFontWeights[i] == 0 ? FontWeight.normal : FontWeight.bold),
                      )
                    : null)
        ]));
  }
}
