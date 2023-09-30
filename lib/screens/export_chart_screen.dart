import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/screens/chart_screens/utils/helper_widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:plotify/widgets/bar_chart.dart';
import 'package:plotify/widgets/line_chart.dart';
import 'package:plotify/widgets/pie_chart.dart';

class ExportChart extends StatefulWidget {
  final Chart chart;
  const ExportChart(this.chart, {super.key});

  @override
  State<ExportChart> createState() => _ExportChartState();
}

class _ExportChartState extends State<ExportChart> {
  int chosenPosition = 0;
  FocusNode node = FocusNode();
  final TextEditingController titleController = TextEditingController();
  late List<Color> legendColors = [];
  late List<String> names = [];
  ScreenshotController controller = ScreenshotController();
  bool showLegend = false;
  bool takingScreenShot = false;
  Color titleColor = Colors.black;

  @override
  void initState() {
    if (widget.chart.type == ChartType.bar) {
      BarChartOptions options = widget.chart.options as BarChartOptions;
      legendColors = [
        for (int i = 0; i < options.isMultiColored.length; i++)
          if (options.isMultiColored[i])
            Colors.black
          else
            Color(options.chartColors[0][i])
      ];
      names = [...options.trackNames];
    } else if (widget.chart.type == ChartType.line) {
      LineChartOptions options = widget.chart.options as LineChartOptions;
      legendColors = [for (int value in options.lineColors) Color(value)];
      names = [...options.lineNames];
    } else {
      PieChartOptions options = widget.chart.options as PieChartOptions;
      legendColors = [for (int value in options.sectionColors) Color(value)];
      names = [...options.sectionNames];
    }
    super.initState();
  }

  Widget get buildLegend {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [BoxShadow(blurRadius: 0.8, offset: Offset(0.25, 0.2))]),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: legendColors.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, childAspectRatio: 12, mainAxisSpacing: 12),
            itemBuilder: (ctx, index) {
              return Row(
                children: [
                  ColorBoxPicker(
                      color: legendColors[index],
                      changeColor: (color) {
                        setState(() {
                          legendColors[index] = color;
                        });
                      }),
                  const SizedBox(
                    width: 16,
                  ),
                  FittedBox(
                      child: Text(
                    names[index].isEmpty ? "Group ${index + 1}" : names[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              );
            }),
      ),
    );
  }

  Widget buildChart(Chart chart) {
    if (chart.type == ChartType.bar) {
      return BarChartWidget(chart, isConfig: false);
    } else if (chart.type == ChartType.line) {
      return LineChartWidget(chart, isConfig: false);
    } else {
      return PieChartWidget(chart);
    }
  }

  @override
  Widget build(BuildContext context) {
    node.unfocus();

    return Screenshot(
      controller: controller,
      child: Scaffold(
        backgroundColor: Color(widget.chart.options.bgColor),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (titleController.text.isNotEmpty)
                Text(
                  titleController.text,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: titleColor
                  ),
                ),
              Expanded(
                child: Center(
                  child: Hero(
                    tag: widget.chart.id,
                    child: buildChart(widget.chart)),
                ),
              ),
              if (showLegend)
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: buildLegend),
              if (!takingScreenShot)
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextField(
                            controller: titleController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration:
                                const InputDecoration(hintText: "Title:"),
                          ),
                          Row(
                            children: [
                              const Text("Title Color"),
                              const SizedBox(width: 16,),
                              ColorBoxPicker(color: titleColor, changeColor: (color) {
                                setState(() {
                                  titleColor = color;
                                });
                              }),
                              const SizedBox(width: 16,),
                              CheckBoxOption(
                                "Show Legend",
                                showLegend,
                                (p0) {
                                  setState(() {
                                    showLegend = p0!;
                                  });
                                },
                                spaceBetween: false,
                              ),
                              const Spacer(),
                              TextButton(
                                child: const Text("Go Back"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    setState(() {
                                      takingScreenShot = true;
                                    });
                                    final directory = await FilePicker.platform
                                        .getDirectoryPath();

                                    if (directory != null) {
                                      controller
                                          .captureAndSave(directory,
                                              fileName:
                                                  "${widget.chart.name}.png",
                                              // ignore: use_build_context_synchronously
                                              pixelRatio: MediaQuery.of(context)
                                                  .devicePixelRatio)
                                          .then((value) {
                                        setState(() {
                                          takingScreenShot = false;
                                        });
                                      });
                                    } else {
                                      setState(() {
                                        takingScreenShot = false;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.image),
                                  label: const Text("Save Screenshot"))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
