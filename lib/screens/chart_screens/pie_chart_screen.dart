import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/providers/charts_provider.dart';
import 'package:plotify/screens/chart_screens/chart_screen_template.dart';
import 'package:plotify/screens/chart_screens/utils/helper_widgets.dart';
import 'package:plotify/screens/export_chart_screen.dart';
import 'package:plotify/screens/pie_chart_data.dart';
import 'package:plotify/widgets/pie_chart.dart';

List<String> fontWeightsText = ["Normal", "Bold"];

class PieChartScreen extends ConsumerStatefulWidget {
  final int index;
  const PieChartScreen(this.index, {super.key});

  @override
  ConsumerState<PieChartScreen> createState() => _PieChartScreenState();
}

class _PieChartScreenState extends ConsumerState<PieChartScreen> {
  List<bool> showSectionOptions = [];
  FocusNode node = FocusNode();
  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    Chart chart = ref.watch(chartsProvider)[widget.index];
    PieChartOptions options = chart.options as PieChartOptions;

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
              width: 350,
              height: 350,
              child: ViewData(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return PieChartData(widget.index);
                })).then((value) {
                  setState(() {
                    isInit = true;
                  });
                });
              })),
        ),
      );
    }
    if (isInit) {
      showSectionOptions = [for (final _ in chart.data) false];
      isInit = false;
    }
    node.unfocus();

    return ChartScreenTemplate(
        Color(options.bgColor),
        [
          TitleAndBackButton(text: chart.name),
          const SizedBox(
            height: 20,
          ),
          ViewData(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return PieChartData(widget.index);
            })).then((value) {
              setState(() {
                isInit = true;
              });
            });
          }),
          const SizedBox(
            height: 20,
          ),
          if (chart.data.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LeftPaddedText(
                  "Section Styles",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SliderRowDouble(
                  "Offset Angle",
                  options.offsetAngle,
                  (p0) {
                    setState(() {
                      options.offsetAngle = p0;
                    });
                  },
                  0,
                  360,
                  360,
                  color: Colors.grey,
                  suffix: "°",
                ),
                SliderRowDouble("Central Distance", options.centerDistance,
                    (p0) {
                  setState(() {
                    options.centerDistance = p0;
                  });
                }, 0, 100, 500),
                SliderRowDouble(
                    "Inter-section spacing", options.sectionsSpacing, (p0) {
                  setState(() {
                    options.sectionsSpacing = p0;
                  });
                }, 0, 10, 100),
              ],
            ),
          for (int i = 0; i < chart.data.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      LeftPaddedText(
                        "Section ${i + 1}",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showSectionOptions[i] = !showSectionOptions[i];
                            });
                          },
                          icon: Icon(showSectionOptions[i]
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down))
                    ],
                  ),
                  if (showSectionOptions[i])
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 12),
                          child: Row(
                            children: [
                              const LeftPaddedText("Section Color"),
                              const SizedBox(
                                width: 20,
                              ),
                              ColorBoxPicker(
                                  color: Color(options.sectionColors[i]),
                                  changeColor: (val) {
                                    setState(() {
                                      options.sectionColors[i] = val.value;
                                    });
                                  })
                            ],
                          ),
                        ),
                        SliderRowDouble(
                            "Section Width", options.sectionWidths[i], (width) {
                          setState(() {
                            options.sectionWidths[i] = width;
                          });
                        }, 10, 175, 500),
                      ],
                    ),
                ],
              ),
            ),
          LeftPaddedText(
            "Additional Configuration Options",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.5, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LeftPaddedText("Background Color"),
                ColorBoxPicker(
                    color: Color(options.bgColor),
                    changeColor: (val) {
                      setState(() {
                        options.bgColor = val.value;
                      });
                    })
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          CheckBoxOption("Show Labels", options.showLabels, (p0) {
            setState(() {
              options.showLabels = !options.showLabels;
            });
          }),
          if (options.showLabels)
            for (int i = 0; i < chart.data.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LeftPaddedText(
                      "Section ${i + 1} Label:",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LeftPaddedText("Color"),
                        ColorBoxPicker(
                            color: Color(options.labelColors[i]),
                            changeColor: (color) {
                              setState(() {
                                options.labelColors[i] = color.value;
                              });
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LeftPaddedText("Font Weight"),
                        DropdownButton(
                            focusNode: node,
                            style: Theme.of(context).textTheme.bodyMedium,
                            value: options.labelFontWeights[i],
                            icon: const Icon(Icons.arrow_drop_down),
                            items: [
                              for (int index = 0;
                                  index < fontWeightsText.length;
                                  index++)
                                DropdownMenuItem(
                                    value: index,
                                    child: Text(fontWeightsText[index]))
                            ],
                            onChanged: (val) {
                              setState(() {
                                options.labelFontWeights[i] = val!;
                              });
                            })
                      ],
                    ),
                    SliderRowPct("Percentage Offset", options.labelOffsets[i],
                        (offsetPct) {
                      setState(() {
                        options.labelOffsets[i] = offsetPct;
                      });
                    }, 0, 200, 200),
                    SliderRowDouble("Font Size", options.labelFontSizes[i],
                        (p0) {
                      setState(() {
                        options.labelFontSizes[i] = p0;
                      });
                    }, 10, 35, 250)
                  ],
                ),
              ),
          const SizedBox(
            height: 8,
          ),
          CheckBoxOption("Show Frequencies", options.showFreq, (p0) {
            setState(() {
              options.showFreq = !options.showFreq;
            });
          }),
          if (options.showFreq)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                    value: true,
                    title: Text(
                      "Include in labels",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    groupValue: options.includeFreqInLabels,
                    onChanged: (val) {
                      setState(() {
                        options.includeFreqInLabels = val!;
                      });
                    }),
                RadioListTile(
                    value: false,
                    title: Text(
                      "Show in sections",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    groupValue: options.includeFreqInLabels,
                    onChanged: (val) {
                      setState(() {
                        options.includeFreqInLabels = val!;
                      });
                    }),
                CheckBoxOption(
                  "Display as percentages",
                  options.showAsPct,
                  (p0) {
                    setState(() {
                      options.showAsPct = p0!;
                    });
                  },
                  spaceBetween: false,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                if (!options.includeFreqInLabels)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < chart.data.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LeftPaddedText(
                                "Section ${i + 1} Frequency:",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const LeftPaddedText("Color"),
                                  ColorBoxPicker(
                                      color: Color(options.freqColors[i]),
                                      changeColor: (color) {
                                        setState(() {
                                          options.freqColors[i] = color.value;
                                        });
                                      })
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const LeftPaddedText("Font Weight"),
                                  DropdownButton(
                                      focusNode: node,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      value: options.freqFontWeights[i],
                                      icon: const Icon(Icons.arrow_drop_down),
                                      items: [
                                        for (int index = 0;
                                            index < fontWeightsText.length;
                                            index++)
                                          DropdownMenuItem(
                                              value: index,
                                              child:
                                                  Text(fontWeightsText[index]))
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          options.freqFontWeights[i] = val!;
                                        });
                                      })
                                ],
                              ),
                              SliderRowDouble(
                                  "Font Size", options.freqFontSizes[i], (p0) {
                                setState(() {
                                  options.freqFontSizes[i] = p0;
                                });
                              }, 10, 35, 250)
                            ],
                          ),
                        )
                    ],
                  ),
              ],
            )
        ],
        Hero(
          tag: chart.id,
          child: PieChartWidget(chart)), 
          callback1: () {
            ref.read(chartsProvider.notifier).addPieToDB(chart);
          },
          callback2: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return ExportChart(chart);
            })
          );
        },);
  }
}
