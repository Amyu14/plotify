import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/screens/chart_screens/utils/helper_widgets.dart';

class LineChartWidget extends StatelessWidget {
  final Chart chart;
  final bool isConfig;
  const LineChartWidget(this.chart, {super.key, this.isConfig = true});

  static double reverseY(double y, double minX, double maxX) {
    return (maxX + minX) - y;
  }

  static List<FlSpot> reverseSpots(
      List<FlSpot> inputSpots, double minY, double maxY) {
    return inputSpots.map((spot) {
      return spot.copyWith(y: (maxY + minY) - spot.y);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final LineChartOptions options = chart.options as LineChartOptions;
    double? height;
    double? width;
    double aspectRatio = getAspectRatio(options.aspectRatioHeight,
        options.aspectRatioWidth, false);

    final List<LineChartBarData> lineBarsData = [
      for (int i = 0; i < chart.data.length; i++)
        LineChartBarData(
            aboveBarData: options.chartStyle == ChartStyle.flipped
                ? BarAreaData(
                    show: options.showAreas[i],
                    gradient: LinearGradient(
                        colors: options.areGradients[i]
                            ? [Color(options.areaColors1[i]), Color(options.areaColors2[i])]
                            : [Color(options.areaColors1[i]), Color(options.areaColors1[i])],
                        begin: options.startAlignments[i],
                        end: options.endAlignments[i]))
                : null,
            belowBarData: options.chartStyle == ChartStyle.vertical
                ? BarAreaData(
                    show: options.showAreas[i],
                    gradient: LinearGradient(
                        colors: options.areGradients[i]
                            ? [Color(options.areaColors1[i]), Color(options.areaColors2[i])]
                            : [Color(options.areaColors1[i]), Color(options.areaColors1[i])],
                        begin: options.startAlignments[i],
                        end: options.endAlignments[i]))
                : null,
            color: Color(options.lineColors[i]),
            barWidth: options.lineWidths[i],
            isCurved: options.style == LineChartStyle.curved ? true : false,
            spots: options.chartStyle == ChartStyle.vertical
                ? [for (final data in chart.data[i]) FlSpot(data[0], data[1])]
                : reverseSpots([
                    for (final data in chart.data[i]) FlSpot(data[0], data[1])
                  ], options.minY, options.maxY),
            dotData: FlDotData(
              show: options.markerStyles[i] != MarkerStyle.none,
              getDotPainter: (p0, p1, p2, p3) {
                return options.markerStyles[i] == MarkerStyle.round
                    ? FlDotCirclePainter(
                        color: Color(options.markerFillColors[i]),
                        radius: options.markerSizes[i] / 3,
                        strokeColor: Color(options.markerOutlineColors[i]),
                        strokeWidth: options.markerWidths[i],
                      )
                    : FlDotSquarePainter(
                        color: Color(options.markerFillColors[i]),
                        size: options.markerSizes[i] / 1.5,
                        strokeColor: Color(options.markerOutlineColors[i]),
                        strokeWidth: options.markerWidths[i],
                      );
              },
            ))
    ];

    return LayoutBuilder(builder: (context, constraints) {
      if (isConfig) {
        height = aspectRatio < 1 ? constraints.maxHeight * 0.9 : null;
        width = aspectRatio >= 1 ? constraints.maxWidth * 0.9 : null;
      } else {
        height = constraints.maxHeight * 0.9;
        if (aspectRatio >= 2) {
          width = constraints.maxWidth * 0.9;
          height = width! / aspectRatio;
        }
      }

      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      options.yLabel,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Color(options.labelColor),
                          fontSize: 16,
                          fontWeight: options.labelWeight == 0 ? FontWeight.normal : FontWeight.bold),
                    )),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (options.chartStyle == ChartStyle.flipped)
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
                      if (options.chartStyle == ChartStyle.flipped)
                        const SizedBox(
                          height: 20,
                        ),
                      SizedBox(
                        height: height,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, right: 16),
                          child: AspectRatio(
                            aspectRatio: options.aspectRatioWidth /
                                options.aspectRatioHeight,
                            child: LineChart(LineChartData(
                                showingTooltipIndicators:
                                    options.showValueLabels
                                        ? [
                                            for (int i = 0;
                                                i < chart.data.length;
                                                i++)
                                              for (int j = 0;
                                                  j < chart.data[i].length;
                                                  j++)
                                                ShowingTooltipIndicators([
                                                  LineBarSpot(
                                                      lineBarsData[i],
                                                      i,
                                                      lineBarsData[i].spots[j])
                                                ])
                                          ]
                                        : [],
                                lineTouchData: LineTouchData(
                                    enabled: true,
                                    handleBuiltInTouches: false,
                                    getTouchedSpotIndicator:
                                        (barData, spotIndexes) {
                                      return spotIndexes.map((index) {
                                        return TouchedSpotIndicatorData(
                                            FlLine(
                                              color: Colors.transparent,
                                            ),
                                            FlDotData(
                                              show: false,
                                            ));
                                      }).toList();
                                    },
                                    touchTooltipData: LineTouchTooltipData(
                                      tooltipBgColor: Color(options.labelBgColor),
                                      tooltipMargin:
                                          options.labelsAbovePoints ? 15 : -45,
                                      getTooltipItems: (touchedSpots) {
                                        return [
                                          for (final spot in touchedSpots)
                                            LineTooltipItem(
                                                options.chartStyle ==
                                                        ChartStyle.flipped
                                                    ? reverseY(
                                                            spot.y,
                                                            options.minY,
                                                            options.maxY)
                                                        .toStringAsFixed(1)
                                                    : spot.y.toStringAsFixed(1),
                                                Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: spot.bar.color))
                                        ];
                                      },
                                    )),
                                minX: options.minX,
                                maxX: options.maxX,
                                minY: options.minY,
                                maxY: options.maxY,
                                baselineY: options.minY,
                                baselineX: options.minX,
                                borderData: FlBorderData(
                                    show: options.showBorder,
                                    border: Border.all(
                                        width: options.borderWidth,
                                        color: Color(options.borderColor))),
                                gridData: FlGridData(
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                        dashArray:
                                            options.areHorizontalLinesDashed
                                                ? [8, 8]
                                                : null,
                                        color: Color(options.horiGridColor),
                                        strokeWidth: options.horiGridWidth);
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                        dashArray:
                                            options.areVerticalLinesDashed
                                                ? [8, 8]
                                                : null,
                                        color: Color(options.vertGridColor),
                                        strokeWidth: options.vertGridWidth);
                                  },
                                  horizontalInterval:
                                      (options.maxY - options.minY) /
                                          options.numDivisionsHoriGrid,
                                  verticalInterval:
                                      (options.maxX - options.minX) /
                                          options.numDivisionsVertGrid,
                                  drawHorizontalLine: options.showGridHori,
                                  drawVerticalLine: options.showGridVert,
                                ),
                                titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                      showTitles: options.chartStyle ==
                                              ChartStyle.vertical &&
                                          options.showXVals,
                                      interval: (options.maxX - options.minX) /
                                          options.numDivisionsVertGrid,
                                      getTitlesWidget: (value, meta) {
                                        return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: Text(
                                              value.toStringAsFixed(1),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color:
                                                          Color(options.xValsColor)),
                                            ));
                                      },
                                    )),
                                    leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                            interval: (options.maxY -
                                                    options.minY) /
                                                options.numDivisionsHoriGrid,
                                            getTitlesWidget: (value, meta) {
                                              double val = options.chartStyle ==
                                                      ChartStyle.vertical
                                                  ? value
                                                  : reverseY(
                                                      value,
                                                      options.minY,
                                                      options.maxY);
                                              return RotatedBox(
                                                quarterTurns: 3,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 6),
                                                    child: Text(
                                                        val.toStringAsFixed(1),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: Color(options
                                                                    .yValsColor)))),
                                              );
                                            },
                                            showTitles: options.showYVals)),
                                    topTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                      showTitles: options.chartStyle ==
                                              ChartStyle.flipped &&
                                          options.showXVals,
                                      interval: (options.maxX - options.minX) /
                                          options.numDivisionsVertGrid,
                                      getTitlesWidget: (value, meta) {
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            child: Text(
                                              value.toStringAsFixed(1),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color:
                                                          Color(options.xValsColor)),
                                            ));
                                      },
                                    )),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false))),
                                lineBarsData: lineBarsData)),
                          ),
                        ),
                      ),
                      if (options.chartStyle == ChartStyle.vertical)
                        const SizedBox(
                          height: 20,
                        ),
                      if (options.chartStyle == ChartStyle.vertical)
                        Text(
                          options.xLabel,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Color(options.labelColor),
                                  fontSize: 16,
                                  fontWeight: options.labelWeight == 0 ? FontWeight.normal : FontWeight.bold),
                        )
                    ],
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
