import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/providers/charts_provider.dart';
import 'package:plotify/screens/bar_chart_data.dart';
import 'package:plotify/screens/chart_screens/chart_screen_template.dart';
import 'package:plotify/screens/chart_screens/utils/helper_widgets.dart';
import 'package:plotify/screens/export_chart_screen.dart';
import 'package:plotify/widgets/bar_chart.dart';

final List<String> multiChartStyleOptions = [
  "Horizontally Stacked",
  "Vertically Stacked"
];

final List<String> barChartStyleOptions = ["Vertical", "Horizontal", "Flipped"];

List<String> fontWeightsText = ["Normal", "Bold"];

class BarChartScreen extends ConsumerStatefulWidget {
  final int index;
  const BarChartScreen(this.index, {super.key});

  @override
  ConsumerState<BarChartScreen> createState() {
    return BarChartScreenState();
  }
}

class BarChartScreenState extends ConsumerState<BarChartScreen> {
  bool showMultiDataStyle = false;
  bool showBarChartStyle = false;
  List<bool>? isMultiColored;
  final TextEditingController aspRatioWidth = TextEditingController();
  final TextEditingController aspRatioHeight = TextEditingController();
  final TextEditingController xAxisLabel = TextEditingController();
  final TextEditingController yAxisLabel = TextEditingController();
  final TextEditingController verticalSpacing = TextEditingController();
  TextEditingController minXController = TextEditingController();
  TextEditingController minYController = TextEditingController();
  TextEditingController maxXController = TextEditingController();
  TextEditingController maxYController = TextEditingController();
  FocusNode node = FocusNode();
  int selectedMultiChartIndex = 0;
  int selectedStyleIndex = 0;
  List<bool>? showGroupColors;

  @override
  void dispose() {
    aspRatioHeight.dispose();
    aspRatioWidth.dispose();
    xAxisLabel.dispose();
    yAxisLabel.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Chart chart = ref.watch(chartsProvider)[widget.index];
    final BarChartOptions options = chart.options as BarChartOptions;
    if (chart.data.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text(
            chart.name,
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 32),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: SizedBox(
              height: 350,
              width: 350,
              child: ViewData(
                () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return BarChartData(widget.index);
                  })).then((value)  {
                    setState(() {
                      showGroupColors = null;
                    });
                  });
                },
                elevation: 2.5,
              )),
        ),
      );
    }

    node.unfocus();
    if (showGroupColors == null) {
      aspRatioHeight.text = options.aspectRatioHeight.toString();
      aspRatioWidth.text = options.aspectRatioWidth.toString();
      verticalSpacing.text = options.verticalGap.toString();
      xAxisLabel.text = options.xLabel;
      yAxisLabel.text = options.yLabel;
      minYController.text = options.minY.toString();
      maxYController.text = options.maxY.toString();
      final int numTracks = chart.data[0].length;
      showGroupColors = [for (int i = 0; i < numTracks; i++) false];
      switch (options.style) {
        case ChartStyle.vertical:
          selectedStyleIndex = 0;
          break;
        case ChartStyle.horizontal:
          selectedStyleIndex = 1;
          break;
        case ChartStyle.flipped:
          selectedStyleIndex = 2;
      }
      switch (options.multiDataStyle) {
        case MultiDataStyle.horizontal:
          selectedMultiChartIndex = 0;
          break;
        case MultiDataStyle.vertical:
          selectedMultiChartIndex = 1;
      }
    }

    return ChartScreenTemplate(
        Color(chart.options.bgColor),
        [
          TitleAndBackButton(text: chart.name),
          const SizedBox(
            height: 20,
          ),
          ViewData(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return BarChartData(widget.index);
            })).then((value) {
              setState(() {
                showGroupColors = null;
              });
            });
          }),
          const SizedBox(
            height: 20,
          ),
          AspectRatioSelection(
              aspRatioWidth: aspRatioWidth,
              aspRatioHeight: aspRatioHeight,
              callback: () {
                if (int.tryParse(aspRatioWidth.text) != null &&
                    int.tryParse(aspRatioHeight.text) != null) {
                  setState(() {
                    options.aspectRatioHeight = int.parse(aspRatioHeight.text);
                    options.aspectRatioWidth = int.parse(aspRatioWidth.text);
                  });
                } else {
                  setState(() {
                    aspRatioHeight.text = options.aspectRatioHeight.toString();
                    aspRatioWidth.text = options.aspectRatioWidth.toString();
                  });
                }
              }),
          buildDropDownTile("Bar Chart Style", showBarChartStyle, () {
            setState(() {
              showBarChartStyle = !showBarChartStyle;
            });
          }),
          if (showBarChartStyle)
            styleOptionsList(3, (int index) {
              setState(() {
                selectedStyleIndex = index;
                switch (selectedStyleIndex) {
                  case 0:
                    options.style = ChartStyle.vertical;
                    break;
                  case 1:
                    options.style = ChartStyle.horizontal;
                    break;
                  case 2:
                    options.style = ChartStyle.flipped;
                }
              });
            }, selectedStyleIndex, barChartStyleOptions, context,
                dirName: "bar_chart_style"),
          const SizedBox(
            height: 16,
          ),
          buildDropDownTile("Multi Chart Style", showMultiDataStyle, () {
            setState(() {
              showMultiDataStyle = !showMultiDataStyle;
            });
          }),
          if (showMultiDataStyle)
            styleOptionsList(2, (int index) {
              setState(() {
                selectedMultiChartIndex = index;
                switch (selectedMultiChartIndex) {
                  case 0:
                    options.multiDataStyle = MultiDataStyle.horizontal;
                    break;
                  case 1:
                    options.multiDataStyle = MultiDataStyle.vertical;
                }
              });
            }, selectedMultiChartIndex, multiChartStyleOptions, context,
                dirName: "multi_chart_styles"),
          const SizedBox(
            height: 16,
          ),
          LeftPaddedText(
            "Axis Constraints",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextFieldRow("Min Y", minYController),
          TextFieldRow("Max Y", maxYController),
          const SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      options.minY = double.parse(minYController.text);
                      options.maxY = double.parse(maxYController.text);
                    });
                  },
                  child: const Text("Set Constraints"))),
          LeftPaddedText(
            "Chart Colors",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(children: [
              Row(
                children: [
                  const Text("Background Color"),
                  const SizedBox(
                    width: 8,
                  ),
                  ColorBoxPicker(
                      color: Color(options.bgColor),
                      changeColor: (Color pickedColor) {
                        setState(() {
                          options.bgColor = pickedColor.value;
                        });
                      }),
                ],
              ),
            ]),
          ),
          for (int trackIndex = 0;
              trackIndex < options.trackNames.length;
              trackIndex++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: [
                Row(
                  children: [
                    Text('Group ${trackIndex + 1} Colors'),
                    const Spacer(),
                    ColorBoxPicker(
                        color: options.isMultiColored[trackIndex]
                            ? Colors.black
                            : Color(options.chartColors[0][trackIndex]),
                        changeColor: (Color pickedColor) {
                          setState(() {
                            for (int i = 0;
                                i < options.chartColors.length;
                                i++) {
                              options.chartColors[i][trackIndex] = pickedColor.value;
                            }
                            options.isMultiColored[trackIndex] = false;
                          });
                        }),
                    IconButton(
                      icon: Icon(showGroupColors![trackIndex]
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                      onPressed: () {
                        setState(() {
                          showGroupColors![trackIndex] =
                              !showGroupColors![trackIndex];
                        });
                      },
                    )
                  ],
                ),
                if (showGroupColors![trackIndex])
                  for (int dataIndex = 0;
                      dataIndex < options.groupNames.length;
                      dataIndex++)
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Text("Group Element ${dataIndex + 1}"),
                          const SizedBox(
                            width: 10,
                          ),
                          ColorBoxPicker(
                              color: Color(options.chartColors[dataIndex][trackIndex]),
                              changeColor: (Color pickedColor) {
                                setState(() {
                                  options.chartColors[dataIndex][trackIndex] =
                                      pickedColor.value;
                                  options.isMultiColored[trackIndex] = true;
                                });
                              }),
                        ],
                      ),
                    ),
              ]),
            ),
          const SizedBox(
            height: 20,
          ),
          LeftPaddedText(
            "Bar Rod Style",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SliderRowPct("Bar Radius", options.radiusPct, (p0) {
            setState(() {
              options.radiusPct = p0;
            });
          }, 0, 100, 100),
          SliderRowPct("Bar Width", options.widthPct, (p0) {
            setState(() {
              options.widthPct = p0;
            });
          }, 0, 100, 100),
          if (options.multiDataStyle == MultiDataStyle.vertical)
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: verticalSpacing,
              decoration: InputDecoration(
                  labelText: "Inter-rod Spacing",
                  suffix: IconButton(
                    onPressed: () {
                      if (double.tryParse(verticalSpacing.text) != null) {
                        setState(() {
                          options.verticalGap =
                              double.parse(verticalSpacing.text);
                        });
                      } else {
                        verticalSpacing.text = options.verticalGap.toString();
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                  )),
            ),
          const SizedBox(
            height: 28,
          ),
          AxisLabels(
            xAxisLabel: xAxisLabel,
            yAxisLabel: yAxisLabel,
            val: Color(options.labelColor),
            callback1: (val) {
              setState(() {
                options.xLabel = val;
              });
            },
            callback2: (val) {
              setState(() {
                options.yLabel = val;
              });
            },
            callback3: (val) {
              setState(() {
                options.labelColor = val.value;
              });
            },
          ),
          Row(
            children: [
              const LeftPaddedText("Font Weight"),
              const SizedBox(width: 16),
              DropdownButton(
                  focusNode: node,
                  style: Theme.of(context).textTheme.bodyMedium,
                  value: options.labelWeight,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: [
                    for (int index = 0; index < fontWeightsText.length; index++)
                      DropdownMenuItem(
                          value: index,
                          child: Text(fontWeightsText[index]))
                  ],
                  onChanged: (val) {
                    setState(() {
                      options.labelWeight = val!;
                    });
                  })
            ],
          ),
          const SizedBox(height: 20),
          LeftPaddedText(
            "Additional Configuration Options",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CheckBoxOption("Show Horizontal Grid", options.showGridHori, (value) {
            setState(() {
              options.showGridHori = value!;
            });
          }),
          if (options.showGridHori)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const LeftPaddedText("Color:"),
                      const SizedBox(
                        width: 16,
                      ),
                      ColorBoxPicker(
                          color: Color(options.horiGridColor),
                          changeColor: (val) {
                            setState(() {
                              options.horiGridColor = val.value;
                            });
                          })
                    ],
                  ),
                ),
                CheckBoxOption(
                  "Dashed Line:",
                  options.areHorizontalLinesDashed,
                  (p0) {
                    setState(() {
                      options.areHorizontalLinesDashed = p0!;
                    });
                  },
                  spaceBetween: false,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SliderRow("Divisions:", options.numDivisionsHoriGrid, (val) {
                  setState(() {
                    options.numDivisionsHoriGrid = val.round();
                  });
                }),
                SliderRowDouble("Width:", options.horiGridWidth, (val) {
                  setState(() {
                    options.horiGridWidth = val;
                  });
                }, 0, 5, 50),
              ],
            ),
          CheckBoxOption("Show Border", options.showBorder, (value) {
            setState(() {
              options.showBorder = value!;
            });
          }),
          if (options.showBorder)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const LeftPaddedText("Color:"),
                      const SizedBox(
                        width: 16,
                      ),
                      ColorBoxPicker(
                          color: Color(options.borderColor),
                          changeColor: (val) {
                            setState(() {
                              options.borderColor = val.value;
                            });
                          })
                    ],
                  ),
                ),
                SliderRowDouble("Width:", options.borderWidth, (val) {
                  setState(() {
                    options.borderWidth = val;
                  });
                }, 0, 5, 50),
              ],
            ),
          CheckBoxOption("Show X Values", options.showXVals, (value) {
            setState(() {
              options.showXVals = value!;
            });
          }),
          if (options.showXVals)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const LeftPaddedText("Color:"),
                  const SizedBox(
                    width: 16,
                  ),
                  ColorBoxPicker(
                      color: Color(options.xValsColor),
                      changeColor: (val) {
                        setState(() {
                          options.xValsColor = val.value;
                        });
                      })
                ],
              ),
            ),
          CheckBoxOption("Show Y Values", options.showYVals, (value) {
            setState(() {
              options.showYVals = value!;
            });
          }),
          if (options.showYVals)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const LeftPaddedText("Color:"),
                  const SizedBox(
                    width: 16,
                  ),
                  ColorBoxPicker(
                      color: Color(options.yValsColor),
                      changeColor: (val) {
                        setState(() {
                          options.yValsColor = val.value;
                        });
                      })
                ],
              ),
            ),
          CheckBoxOption("Show Value Labels", options.showValueLabels, (p0) {
            setState(() {
              options.showValueLabels = p0!;
            });
          }),
          if (options.showValueLabels)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const LeftPaddedText("Label Background Color:"),
                  const SizedBox(
                    width: 16,
                  ),
                  ColorBoxPicker(
                      color: Color(options.labelBgColor),
                      changeColor: (val) {
                        setState(() {
                          options.labelBgColor = val.value;
                        });
                      })
                ],
              ),
            ),
        ],
        Hero(
          tag: chart.id,
          child: BarChartWidget(chart)), callback1: () {
            ref.read(chartsProvider.notifier).addBarToDB(chart);
          }, callback2: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return ExportChart(chart);
          }));
        },);
  }
}
