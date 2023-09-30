import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/providers/charts_provider.dart';
import 'package:plotify/screens/chart_screens/chart_screen_template.dart';
import 'package:plotify/screens/chart_screens/utils/helper_widgets.dart';
import 'package:plotify/screens/export_chart_screen.dart';
import 'package:plotify/screens/line_chart_data.dart';
import 'package:plotify/widgets/line_chart.dart';

final List<String> lineStyleOptions = ["Straight", "Curved"];

final List<String> chartStyleOptions = ["Vertical", "Flipped"];

final List<String> markerStyleOptions = ["Round", "Square"];

List<String> fontWeightsText = ["Normal", "Bold"];

final List<Alignment> alignmentOptions = [
  Alignment.bottomCenter,
  Alignment.bottomLeft,
  Alignment.bottomRight,
  Alignment.center,
  Alignment.centerLeft,
  Alignment.centerRight,
  Alignment.topCenter,
  Alignment.topLeft,
  Alignment.topRight
];

final List<String> alignmentOptionsText = [
  "Bottom Center",
  "Bottom Left",
  "Bottom Right",
  "Center",
  "Center Left",
  "Center Right",
  "Top Center",
  "Top Left",
  "Top Right"
];

class LineChartScreen extends ConsumerStatefulWidget {
  final int index;
  const LineChartScreen(this.index, {super.key});

  @override
  ConsumerState<LineChartScreen> createState() => _LineChartScreenState();
}

class _LineChartScreenState extends ConsumerState<LineChartScreen> {
  TextEditingController aspectRatioWidth = TextEditingController();
  TextEditingController aspectRatioHeight = TextEditingController();
  TextEditingController xAxisLabel = TextEditingController();
  TextEditingController yAxisLabel = TextEditingController();
  TextEditingController minXController = TextEditingController();
  TextEditingController minYController = TextEditingController();
  TextEditingController maxXController = TextEditingController();
  TextEditingController maxYController = TextEditingController();
  late FocusNode node;
  late FocusNode startAlignmentNode;
  late FocusNode endAlignmentNode;
  int selectedLineStyleIndex = 0;
  int selectedChartStyleIndex = 0;
  bool showChartStyle = false;
  bool showLineStyle = false;
  bool showMarkers = false;
  bool isInit = true;

  @override
  void initState() {
    startAlignmentNode = FocusNode();
    endAlignmentNode = FocusNode();
    node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    startAlignmentNode.dispose();
    endAlignmentNode.dispose();
    node.dispose();
    xAxisLabel.dispose();
    yAxisLabel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Chart chart = ref.watch(chartsProvider)[widget.index];
    final LineChartOptions options = chart.options as LineChartOptions;
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey.shade800,
              )),
        ),
        body: Center(
          child: SizedBox(
              width: 350,
              height: 350,
              child: ViewData(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return LineChartData(widget.index);
                })).then((value) {
                  setState(() {});
                });
              })),
        ),
      );
    }

    if (isInit) {
      aspectRatioHeight.text = options.aspectRatioHeight.toString();
      aspectRatioWidth.text = options.aspectRatioWidth.toString();
      xAxisLabel.text = options.xLabel;
      yAxisLabel.text = options.yLabel;
      minXController.text = options.minX.toString();
      minYController.text = options.minY.toString();
      maxXController.text = options.maxX.toString();
      maxYController.text = options.maxY.toString();
      isInit = false;
    }

    startAlignmentNode.unfocus();
    endAlignmentNode.unfocus();
    node.unfocus();

    return ChartScreenTemplate(
        Color(chart.options.bgColor),
        [
          TitleAndBackButton(text: chart.name),
          const SizedBox(
            height: 20,
          ),
          ViewData(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return LineChartData(widget.index);
            })).then((value) {
              setState(() {});
            });
          }),
          const SizedBox(
            height: 20,
          ),
          AspectRatioSelection(
            aspRatioWidth: aspectRatioWidth,
            aspRatioHeight: aspectRatioHeight,
            callback: () {
              setState(() {
                if (int.tryParse(aspectRatioWidth.text) != null &&
                    int.tryParse(aspectRatioHeight.text) != null) {
                  options.aspectRatioHeight = int.parse(aspectRatioHeight.text);
                  options.aspectRatioWidth = int.parse(aspectRatioWidth.text);
                } else {
                  aspectRatioHeight.text = options.aspectRatioHeight.toString();
                  aspectRatioWidth.text = options.aspectRatioWidth.toString();
                }
              });
            },
          ),
          buildDropDownTile("Chart Style", showChartStyle, () {
            setState(() {
              showChartStyle = !showChartStyle;
            });
          }),
          if (showChartStyle)
            styleOptionsList(2, (int index) {
              setState(() {
                selectedChartStyleIndex = index;
                options.chartStyle = ChartStyle.values[index == 0 ? 0 : 2];
              });
            }, selectedChartStyleIndex, chartStyleOptions, context,
                dirName: "chart_style"),
          buildDropDownTile("Line Style", showLineStyle, () {
            setState(() {
              showLineStyle = !showLineStyle;
            });
          }),
          if (showLineStyle)
            styleOptionsList(2, (int index) {
              setState(() {
                selectedLineStyleIndex = index;
                options.style = LineChartStyle.values[index];
              });
            }, selectedLineStyleIndex, lineStyleOptions, context,
                dirName: "line_chart_style"),
          const SizedBox(
            height: 16,
          ),
          LeftPaddedText(
            "Axis Constraints",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextFieldRow("Min X", minXController),
          TextFieldRow("Min Y", minYController),
          TextFieldRow("Max X", maxXController),
          TextFieldRow("Max Y", maxYController),
          const SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      options.minX = double.parse(minXController.text);
                      options.minY = double.parse(minYController.text);
                      options.maxX = double.parse(maxXController.text);
                      options.maxY = double.parse(maxYController.text);
                    });
                  },
                  child: const Text("Set Constraints"))),
          if (options.lineColors.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: LeftPaddedText(
                "Line Colors",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          for (int i = 0; i < options.lineColors.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  LeftPaddedText("Line ${i + 1}"),
                  const SizedBox(
                    width: 20,
                  ),
                  ColorBoxPicker(
                      color: Color(options.lineColors[i]),
                      changeColor: (Color color) {
                        setState(() {
                          options.lineColors[i] = color.value;
                        });
                      })
                ],
              ),
            ),
          if (options.lineWidths.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: LeftPaddedText(
                "Line Widths",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          for (int i = 0; i < options.lineWidths.length; i++)
            SliderRowDouble("Line ${i + 1}", options.lineWidths[i],
                (double value) {
              setState(() {
                options.lineWidths[i] = value;
              });
            }, 0, 5, 50),
          const SizedBox(
            height: 8,
          ),
          if (chart.data.isNotEmpty)
            LeftPaddedText(
              "Line Area Options",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          for (int i = 0; i < chart.data.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeftPaddedText(
                    "Line ${i + 1}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  CheckBoxOption("Show Area Under Line", options.showAreas[i],
                      (value) {
                    setState(() {
                      options.showAreas[i] = value!;
                    });
                  }),
                  if (options.showAreas[i])
                    Column(
                      children: [
                        RadioListTile(
                            value: false,
                            title: Text(
                              "Color Fill",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                            groupValue: options.areGradients[i],
                            onChanged: (val) {
                              setState(() {
                                options.areGradients[i] = false;
                              });
                            }),
                        if (options.areGradients[i] == false)
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 66),
                                child: Text("Area Color"),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              ColorBoxPicker(
                                  color: Color(options.areaColors1[i]),
                                  changeColor: (value) {
                                    setState(() {
                                      options.areaColors1[i] = value.value;
                                      options.areaColors2[i] = value.value;
                                    });
                                  })
                            ],
                          ),
                        RadioListTile(
                            value: true,
                            title: Text("Gradient Fill",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                            groupValue: options.areGradients[i],
                            onChanged: (val) {
                              setState(() {
                                options.areGradients[i] = true;
                              });
                            }),
                        if (options.areGradients[i] == true)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 16, 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 66),
                                      child: Text("Start Color"),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    ColorBoxPicker(
                                        color: Color(options.areaColors1[i]),
                                        changeColor: (value) {
                                          setState(() {
                                            options.areaColors1[i] = value.value;
                                          });
                                        })
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 66),
                                      child: Text("End Color"),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    ColorBoxPicker(
                                        color: Color(options.areaColors2[i]),
                                        changeColor: (value) {
                                          setState(() {
                                            options.areaColors2[i] = value.value;
                                          });
                                        })
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 66),
                                    child: Text("Start Alignment"),
                                  ),
                                  DropdownButton(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      value: options.startAlignments[i],
                                      focusNode: startAlignmentNode,
                                      items: [
                                        for (int x = 0;
                                            x < alignmentOptions.length;
                                            x++)
                                          DropdownMenuItem(
                                            value: alignmentOptions[x],
                                            child:
                                                Text(alignmentOptionsText[x]),
                                          )
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          options.startAlignments[i] = val!;
                                        });
                                      })
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 66),
                                    child: Text("End Alignment"),
                                  ),
                                  DropdownButton(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      value: options.endAlignments[i],
                                      focusNode: endAlignmentNode,
                                      items: [
                                        for (int x = 0;
                                            x < alignmentOptions.length;
                                            x++)
                                          DropdownMenuItem(
                                            value: alignmentOptions[x],
                                            child:
                                                Text(alignmentOptionsText[x]),
                                          )
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          options.endAlignments[i] = val!;
                                        });
                                      })
                                ],
                              )
                            ],
                          ),
                      ],
                    )
                ],
              ),
            ),
          const SizedBox(
            height: 8,
          ),
          if (chart.data.isNotEmpty)
            LeftPaddedText(
              "Marker options",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          for (int i = 0; i < chart.data.length; i++)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LeftPaddedText(
                      'Line ${i + 1}:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    CheckBoxOption("Show Markers",
                        options.markerStyles[i] != MarkerStyle.none,
                        (bool? val) {
                      setState(() {
                        if (options.markerStyles[i] != MarkerStyle.none) {
                          setState(() {
                            options.markerStyles[i] = MarkerStyle.none;
                          });
                        } else {
                          setState(() {
                            options.markerStyles[i] = MarkerStyle.round;
                          });
                        }
                      });
                    }),
                    if (options.markerStyles[i] != MarkerStyle.none)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        markerStyleOptions[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      buildMarker(
                                          Color(options.markerFillColors[i]),
                                          Color(options.markerOutlineColors[i]),
                                          options.markerWidths[i],
                                          options.markerSizes[i],
                                          index == 0 ? 16 : 2),
                                    ],
                                  ),
                                  value: MarkerStyle.values[index + 1],
                                  groupValue: options.markerStyles[i],
                                  onChanged: (val) {
                                    setState(() {
                                      options.markerStyles[i] = val!;
                                    });
                                  });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LeftPaddedText("Fill Color"),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.5),
                                  child: ColorBoxPicker(
                                      color: Color(options.markerFillColors[i]),
                                      changeColor: (color) {
                                        setState(() {
                                          options.markerFillColors[i] = color.value;
                                        });
                                      }),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LeftPaddedText("Border Color"),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.5),
                                  child: ColorBoxPicker(
                                      color: Color(options.markerOutlineColors[i]),
                                      changeColor: (color) {
                                        setState(() {
                                          options.markerOutlineColors[i] =
                                              color.value;
                                        });
                                      }),
                                )
                              ],
                            ),
                          ),
                          SliderRowDouble("Marker Size", options.markerSizes[i],
                              (val) {
                            setState(() {
                              options.markerSizes[i] = val;
                            });
                          }, 0, 30, 100),
                          SliderRowDouble(
                              "Marker Width", options.markerWidths[i], (val) {
                            setState(() {
                              options.markerWidths[i] = val;
                            });
                          }, 0.0, 5.0, 100)
                        ],
                      ),
                  ],
                )),
          const SizedBox(
            height: 8,
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
          const SizedBox(
            height: 32,
          ),
          LeftPaddedText(
            "Additional Configuration Options",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LeftPaddedText("Background Color"),
                Padding(
                  padding: const EdgeInsets.only(right: 8.5),
                  child: ColorBoxPicker(
                      color: Color(options.bgColor),
                      changeColor: (color) {
                        setState(() {
                          options.bgColor = color.value;
                        });
                      }),
                )
              ],
            ),
          ),
          CheckBoxOption("Show Horizontal Lines", options.showGridHori,
              (value) {
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
                }, 0, 5, 100),
              ],
            ),
          CheckBoxOption("Show Vertical Lines", options.showGridVert, (value) {
            setState(() {
              options.showGridVert = value!;
            });
          }),
          if (options.showGridVert)
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
                          color: Color(options.vertGridColor),
                          changeColor: (val) {
                            setState(() {
                              options.vertGridColor = val.value;
                            });
                          })
                    ],
                  ),
                ),
                CheckBoxOption(
                  "Dashed Line:",
                  options.areVerticalLinesDashed,
                  (p0) {
                    setState(() {
                      options.areVerticalLinesDashed = p0!;
                    });
                  },
                  spaceBetween: false,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SliderRow("Divisions:", options.numDivisionsVertGrid, (val) {
                  setState(() {
                    options.numDivisionsVertGrid = val.round();
                  });
                }),
                SliderRowDouble("Width:", options.vertGridWidth, (val) {
                  setState(() {
                    options.vertGridWidth = val;
                  });
                }, 0, 5, 100),
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
                }, 0, 5, 100),
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
            Column(
              children: [
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
                RadioListTile(
                  title: Text("Labels above points", style: Theme.of(context).textTheme.bodyMedium,),
                    value: true,
                    groupValue: options.labelsAbovePoints,
                    onChanged: (val) {
                      setState(() {
                        options.labelsAbovePoints = val!;
                      });
                    }),
                RadioListTile(
                  title: Text("Labels below points", style: Theme.of(context).textTheme.bodyMedium,),
                    value: false,
                    groupValue: options.labelsAbovePoints,
                    onChanged: (val) {
                      setState(() {
                        options.labelsAbovePoints = val!;
                      });
                    })
              ],
            ),
        ],
        Hero(
          tag: chart.id,
          child: LineChartWidget(chart)), 
        callback1: () {
          ref.read(chartsProvider.notifier).addLineToDB(chart);
        },
        callback2: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) {
              return ExportChart(chart);
            })
          );
        },);
  }
}
