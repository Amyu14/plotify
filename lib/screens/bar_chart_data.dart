import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plotify/constants.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/providers/charts_provider.dart';
import 'package:plotify/screens/chart_screens/utils/helper_widgets.dart';

class BarChartData extends ConsumerStatefulWidget {
  final int index;
  const BarChartData(this.index, {super.key});

  @override
  ConsumerState<BarChartData> createState() => _BarChartDataState();
}


class _BarChartDataState extends ConsumerState<BarChartData> {
  final List<List<TextEditingController>> dataValueControllers = [];
  final List<TextEditingController> groupTitleControllers = [];
  final List<TextEditingController> trackTitleControllers = [];

  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    Chart chart = ref.watch(chartsProvider)[widget.index];
    BarChartOptions options = chart.options as BarChartOptions;

    if (chart.data.isEmpty) {
      setState(() {
        chart.data.add([0.0]);
        options.groupNames.add("");
        options.trackNames.add("");
        options.chartColors.add([standardColors[0].value]);
        options.isMultiColored.add(false);
      });
      isInit = true;
    }

    if (isInit) {
      for (int groupNum = 0; groupNum < chart.data.length; groupNum++) {
        dataValueControllers.add([]);
        for (int trackNum = 0; trackNum < chart.data[0].length; trackNum++) {
          dataValueControllers[groupNum].add(TextEditingController()
            ..text = chart.data[groupNum][trackNum].toString());
        }
      }
      for (int groupNum = 0; groupNum < options.groupNames.length; groupNum++) {
        groupTitleControllers
            .add(TextEditingController()..text = options.groupNames[groupNum]);
      }

      for (int trackNum = 0; trackNum < options.trackNames.length; trackNum++) {
        trackTitleControllers
            .add(TextEditingController()..text = options.trackNames[trackNum]);
      }
      isInit = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 0,
        title: Text(
          chart.name,
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 32),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                for (int groupNum = 0;
                    groupNum < groupTitleControllers.length;
                    groupNum++) {
                  options.groupNames[groupNum] =
                      groupTitleControllers[groupNum].text;
                }

                for (int trackNum = 0;
                    trackNum < trackTitleControllers.length;
                    trackNum++) {
                  options.trackNames[trackNum] =
                      trackTitleControllers[trackNum].text;
                }
                options.cumSum = [];
                for (int groupNum = 0;
                    groupNum < groupTitleControllers.length;
                    groupNum++) {
                  options.cumSum.add([0.0]);
                  for (int trackNum = 0;
                      trackNum < trackTitleControllers.length;
                      trackNum++) {
                      double res = double.tryParse(dataValueControllers[groupNum][trackNum].text) ?? 0.0;
                      chart.data[groupNum][trackNum] = res;
                      if (trackNum < trackTitleControllers.length - 1) {
                        options.cumSum[groupNum].add(options.cumSum[groupNum][trackNum]);
                        options.cumSum[groupNum][trackNum + 1] += res;
                      } 
                  }
                }
                Navigator.of(context).pop();
              },
              label: const Text("Save and Return"),
              icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddButton("Add Row", () {
                setState(() {
                  chart.data.add(
                      [for (int i = 0; i < options.trackNames.length; i++) 0.0]);
                  options.chartColors.add([
                    for (int i = 0; i < options.trackNames.length; i++)
                      options.chartColors[0][i]
                  ]);
                  options.groupNames.add("");
                  groupTitleControllers.add(TextEditingController());
                  dataValueControllers.add([
                    for (int i = 0; i < options.trackNames.length; i++)
                      TextEditingController()..text = "0.0"
                  ]);
                });
              }),
              const SizedBox(
                width: 10,
              ),
              AddButton("Add Column", () {
                setState(() {
                  options.trackNames.add("");
                  options.isMultiColored.add(false);
                  trackTitleControllers.add(TextEditingController());
                  for (int i = 0; i < options.groupNames.length; i++) {
                    chart.data[i].add(0.0);
                    dataValueControllers[i]
                        .add(TextEditingController()..text = "0.0");
                    options.chartColors[i]
                        .add(standardColors[trackTitleControllers.length % standardColors.length].value);
                  }
                });
              })
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    for (int i = 0; i < chart.data[0].length + 1; i++)
                      i: const FlexColumnWidth()
                  },
                  children: [
                    TableRow(children: [
                      for (int trackNum = 0;
                          trackNum < trackTitleControllers.length + 1;
                          trackNum++)
                        trackNum == 0
                            ? Container()
                            : TitleField(trackTitleControllers[trackNum - 1],
                                "Group $trackNum title:", () {
                                setState(() {
                                  if (options.trackNames.length == 1) {
                                    chart.data = [];
                                    dataValueControllers.clear();
                                    groupTitleControllers.clear();
                                    options.groupNames.clear();
                                    options.chartColors.clear();
                                  } else {
                                    for (int i = 0;
                                        i < options.groupNames.length;
                                        i++) {
                                      chart.data[i].removeAt(trackNum - 1);
                                      dataValueControllers[i]
                                          .removeAt(trackNum - 1);
                                      options.chartColors[i]
                                          .removeAt(trackNum - 1);
                                    }
                                  }
                                  trackTitleControllers.removeAt(trackNum - 1);
                                  options.trackNames.removeAt(trackNum - 1);
                                });
                              })
                    ]),
                    for (int groupNum = 0;
                        groupNum < groupTitleControllers.length;
                        groupNum++)
                      TableRow(children: [
                        for (int trackNum = 0;
                            trackNum < trackTitleControllers.length + 1;
                            trackNum++)
                          trackNum == 0
                              ? TitleField(
                                  groupTitleControllers[groupNum], "X Label:",
                                  () {
                                  setState(() {
                                    chart.data.removeAt(groupNum);
                                    options.groupNames.removeAt(groupNum);
                                    groupTitleControllers.removeAt(groupNum);
                                    dataValueControllers.removeAt(groupNum);
                                    options.chartColors.removeAt(groupNum);
                                    if (options.groupNames.isEmpty) {
                                      trackTitleControllers.clear();
                                      options.trackNames.clear();
                                    }
                                  });
                                })
                              : ValueField(
                                  dataValueControllers[groupNum][trackNum - 1])
                      ])
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleField extends StatelessWidget {
  const TitleField(
    this.controller,
    this.text,
    this.callback, {
    super.key,
  });

  final String text;
  final TextEditingController controller;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Colors.white, border: Border.all(width: 0.25)),
      child: Row(children: [
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: text),
            controller: controller,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Color.fromARGB(255, 170, 197, 227),
            size: 18,
          ),
          onPressed: callback,
        ),
      ]),
    );
  }
}

class ValueField extends StatelessWidget {
  const ValueField(
    this.controller, {
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 0.5)),
      child: Center(
        child: TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          controller: controller,
        ),
      ),
    );
  }
}
