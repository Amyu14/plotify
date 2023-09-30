import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/screens/chart_screens/utils/helper_widgets.dart';

int maxIndex(List<double> vals) {
  int maxIndex = 0;
  for (int i = 0; i < vals.length; i++) {
    if (vals[i] >= vals[maxIndex]) {
      maxIndex = i;
    }
  }
  return maxIndex;
}

class BarChartWidget extends StatelessWidget {
  final Chart chart;
  final bool isConfig;
  const BarChartWidget(this.chart, {super.key, this.isConfig = true});

  @override
  Widget build(BuildContext context) {
    final BarChartOptions options = chart.options as BarChartOptions;

    double aspectRatio = getAspectRatio(options.aspectRatioHeight,
        options.aspectRatioWidth, options.style == ChartStyle.horizontal);

    double? height;
    double? width;

    return LayoutBuilder(builder: (ctx, constraints) {

      if (isConfig) {
        if (options.style == ChartStyle.horizontal) {
          height = aspectRatio >= 1 ? constraints.maxHeight * 0.9 : null;
          width = aspectRatio < 1 ? constraints.maxWidth * 0.9 : null;
        } else {
          height = aspectRatio < 1 ? constraints.maxHeight * 0.9 : null;
          width = aspectRatio >= 1 ? constraints.maxWidth * 0.9 : null;
        }
      } else {
        if (options.style == ChartStyle.horizontal) {
          height = constraints.maxHeight * 0.9;
        } else {
          height = constraints.maxHeight * 0.9;
          if (aspectRatio >= 2) {
            width = constraints.maxWidth * 0.9;
            height = width! / aspectRatio;
          } 
        }

      }
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                    quarterTurns: options.style == ChartStyle.horizontal ? 1 : -1,
                    child: Text(
                      options.yLabel,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Color(options.labelColor),
                            fontWeight: options.labelWeight == 0 ? FontWeight.normal : FontWeight.bold,
                            fontSize: 16,
                          ),
                    )),
                Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (options.style == ChartStyle.horizontal ||
                            options.style == ChartStyle.flipped)
                          Text(
                            options.xLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Color(options.labelColor),
                                    fontSize: 16,
                                    fontWeight: options.labelWeight == 0 ? FontWeight.normal : FontWeight.bold),
                          ),
                        SizedBox(
                          height: height,
                          width: width,
                          child: RotatedBox(
                              quarterTurns: options.style == ChartStyle.horizontal
                                  ? 1
                                  : (options.style == ChartStyle.flipped ? 2 : 0),
                              child: ChartArea(options: options, chart: chart)),
                        ),
                        if (options.style == ChartStyle.vertical)
                          Text(
                            options.xLabel,
                            style:
                                Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Color(options.labelColor),
                                      fontWeight: options.labelWeight == 0 ? FontWeight.normal : FontWeight.bold,
                                      fontSize: 16,
                                    ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ChartArea extends StatelessWidget {
  const ChartArea({
    super.key,
    required this.options,
    required this.chart,
  });

  final BarChartOptions options;
  final Chart chart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: options.style == ChartStyle.horizontal
            ? options.aspectRatioHeight / options.aspectRatioWidth
            : options.aspectRatioWidth / options.aspectRatioHeight,
        child: BarChart(BarChartData(
          barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                  tooltipRoundedRadius: 5,
                  rotateAngle: options.style == ChartStyle.horizontal
                      ? -90
                      : (options.style == ChartStyle.flipped ? 180 : 0),
                  tooltipPadding: options.style == ChartStyle.horizontal
                      ? const EdgeInsets.fromLTRB(8, 8, 8, 2)
                      : const EdgeInsets.only(
                          top: 5, right: 8, left: 8, bottom: 1),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return options.style != ChartStyle.horizontal
                        ? (options.style == ChartStyle.flipped
                            ? BarTooltipItem(
                                textDirection: TextDirection.rtl,
                                "",
                                Theme.of(context).textTheme.bodyMedium!,
                                children: [
                                    for (int i = 0;
                                        i < group.barRods.length;
                                        i++)
                                      TextSpan(
                                          text: (group.barRods[i].toY -
                                                      group.barRods[i].fromY)
                                                  .toStringAsFixed(1) +
                                              (i != group.barRods.length - 1
                                                  ? (options.multiDataStyle ==
                                                          MultiDataStyle
                                                              .vertical
                                                      ? "\n"
                                                      : "  ")
                                                  : ""),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Color(options.chartColors[
                                                      groupIndex][i]))),
                                  ])
                            : BarTooltipItem(
                                "", Theme.of(context).textTheme.bodyMedium!,
                                textDirection: TextDirection.rtl,
                                children: [
                                    for (int i = group.barRods.length - 1;
                                        i >= 0;
                                        i--)
                                      TextSpan(
                                          text: (group.barRods[i].toY -
                                                      group.barRods[i].fromY)
                                                  .toStringAsFixed(1) +
                                              (i != 0
                                                  ? (options.multiDataStyle ==
                                                          MultiDataStyle
                                                              .vertical
                                                      ? "\n"
                                                      : "  ")
                                                  : ""),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Color(options.chartColors[
                                                      groupIndex][i]))),
                                  ]))
                        : BarTooltipItem(
                            "", Theme.of(context).textTheme.bodyMedium!,
                            children: [
                                for (int i = 0;
                                    i <= group.barRods.length - 1;
                                    i++)
                                  TextSpan(
                                      text: (group.barRods[i].toY -
                                                  group.barRods[i].fromY)
                                              .toStringAsFixed(1) +
                                          (i != group.barRods.length - 1
                                              ? (options.multiDataStyle ==
                                                      MultiDataStyle.horizontal
                                                  ? "\n"
                                                  : "  ")
                                              : ""),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Color(options
                                                  .chartColors[groupIndex][i]))),
                              ]);
                  },
                  tooltipBgColor: Color(options.labelBgColor))),
          barGroups: [
            for (int i = 0; i < chart.data.length; i++)
              BarChartGroupData(
                  showingTooltipIndicators: options.showValueLabels
                      ? (options.multiDataStyle == MultiDataStyle.horizontal
                          ? [maxIndex(chart.data[i])]
                          : [chart.data[i].length - 1])
                      : [],
                  x: i,
                  groupVertically:
                      options.multiDataStyle == MultiDataStyle.vertical
                          ? true
                          : false,
                  barsSpace: 3,
                  barRods: [
                    for (int j = 0; j < chart.data[i].length; j++)
                      BarChartRodData(
                        width: 40 * (options.widthPct / 100),
                        borderRadius: BorderRadius.all(Radius.circular(20 *
                            (options.widthPct / 100) *
                            (options.radiusPct / 100))),
                        color: Color(options.chartColors[i][j]),
                        fromY:
                            options.multiDataStyle == MultiDataStyle.horizontal
                                ? 0
                                : (j == 0
                                    ? 0
                                    : options.cumSum[i][j] +
                                        options.verticalGap * j),
                        toY: options.multiDataStyle == MultiDataStyle.horizontal
                            ? chart.data[i][j].toDouble()
                            : j == 0
                                ? chart.data[i][j].toDouble()
                                : chart.data[i][j].toDouble() +
                                    options.cumSum[i][j] +
                                    options.verticalGap * j,
                      )
                  ])
          ],
          baselineY: options.minY,
          maxY: options.maxY,
          minY: options.minY,
          titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: options.showYVals &&
                          options.style == ChartStyle.flipped,
                      getTitlesWidget: (value, meta) {
                        return RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            value.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Color(options.yValsColor)),
                          ),
                        );
                      },
                      interval: (options.maxY - options.minY) /
                          options.numDivisionsHoriGrid)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: options.showXVals,
                  getTitlesWidget: (value, meta) {
                    return RotatedBox(
                      quarterTurns: options.style == ChartStyle.flipped ? 2 : 0,
                      child: Padding(
                        padding: options.style == ChartStyle.flipped
                            ? const EdgeInsets.only(bottom: 8)
                            : const EdgeInsets.only(top: 8),
                        child: Text(
                          options.groupNames[value.toInt()].toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Color(options.xValsColor)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: options.showYVals &&
                          options.style != ChartStyle.flipped,
                      getTitlesWidget: (value, meta) {
                        return RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            value.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Color(options.yValsColor)),
                          ),
                        );
                      },
                      interval: (options.maxY - options.minY) /
                          options.numDivisionsHoriGrid))),
          borderData: FlBorderData(
              show: options.showBorder,
              border: Border.all(
                  width: options.borderWidth, color: Color(options.borderColor))),
          gridData: FlGridData(
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  dashArray: options.areHorizontalLinesDashed ? [8, 8] : null,
                  color: Color(options.horiGridColor),
                  strokeWidth: options.horiGridWidth);
            },
            horizontalInterval:
                (options.maxY - options.minY) / options.numDivisionsHoriGrid,
            drawHorizontalLine: options.showGridHori,
            drawVerticalLine: false,
          ),
        )),
      ),
    );
  }
}
