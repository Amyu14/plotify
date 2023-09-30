import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plotify/constants.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/providers/charts_provider.dart';

class LineChartData extends ConsumerStatefulWidget {
  final int index;
  const LineChartData(this.index, {super.key});

  @override
  ConsumerState<LineChartData> createState() => _LineChartDataState();
}

class _LineChartDataState extends ConsumerState<LineChartData> {
  final List<List<TextEditingController>> xDataValueControllers = [];
  final List<List<TextEditingController>> yDataValueControllers = [];
  final List<TextEditingController> lineTitleControllers = [];

  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    Chart chart = ref.watch(chartsProvider)[widget.index];
    LineChartOptions options = chart.options as LineChartOptions;

    if (chart.data.isEmpty) {
      setState(() {
        chart.data.add([
          [0.0, 0.0]
        ]);
        options.lineNames.add("");
        options.areGradients.add(false);
        options.lineColors.add(standardColors[0].value);
        options.lineWidths.add(1.0);
        options.markerStyles.add(MarkerStyle.round);
        options.markerOutlineColors.add(standardColors[0].value);
        options.markerFillColors.add(Colors.white.value);
        options.markerSizes.add(15.0);
        options.markerWidths.add(1.5);
        options.areaColors1.add(const Color.fromARGB(117, 147, 193, 231).value);
        options.areaColors2.add(const Color.fromARGB(117, 209, 147, 231).value);
        options.showAreas.add(false);
        options.startAlignments.add(Alignment.bottomLeft);
        options.endAlignments.add(Alignment.topRight);
      });
      isInit = true;
    }

    if (isInit) {
      for (int lineNum = 0; lineNum < options.lineNames.length; lineNum++) {
        lineTitleControllers
            .add(TextEditingController()..text = options.lineNames[lineNum]);
      }

      for (int i = 0; i < chart.data.length; i++) {
        xDataValueControllers.add([]);
        yDataValueControllers.add([]);
        for (int j = 0; j < chart.data[i].length; j++) {
          xDataValueControllers[i].add(
              TextEditingController()..text = chart.data[i][j][0].toString());
          yDataValueControllers[i].add(
              TextEditingController()..text = chart.data[i][j][1].toString());
        }
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
                for (int lineNum = 0; lineNum < xDataValueControllers.length; lineNum++) {
                  options.lineNames[lineNum] = lineTitleControllers[lineNum].text;
                  for (int valNum = 0; valNum < xDataValueControllers[lineNum].length; valNum++) {
                    chart.data[lineNum][valNum] = [
                      double.tryParse(xDataValueControllers[lineNum][valNum].text) ?? 0.0,
                      double.tryParse(yDataValueControllers[lineNum][valNum].text) ?? 0.0,
                    ];
                  }
                }
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save),
              label: const Text("Save and Return"))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                chart.data.add([
                  [0.0, 0.0]
                ]);
                xDataValueControllers.add([TextEditingController()]);
                yDataValueControllers.add([TextEditingController()]);
                lineTitleControllers.add(TextEditingController());

                options.lineNames.add("");
                options.areGradients.add(false);
                options.lineColors.add(standardColors[
                    lineTitleControllers.length % standardColors.length].value);
                options.lineWidths.add(1.0);
                options.markerStyles.add(MarkerStyle.round);
                options.markerOutlineColors.add(standardColors[
                    lineTitleControllers.length % standardColors.length].value);
                options.markerFillColors.add(Colors.white.value);
                options.markerSizes.add(15.0);
                options.markerWidths.add(1.5);
                options.areaColors1
                    .add(const Color.fromARGB(117, 147, 193, 231).value);
                options.areaColors2
                    .add(const Color.fromARGB(117, 209, 147, 231).value);
                options.showAreas.add(false);
                options.startAlignments.add(Alignment.bottomLeft);
                options.endAlignments.add(Alignment.topRight);
              });
            },
            label: const Text("Add New Line"),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int lineNum = 0;
                        lineNum < xDataValueControllers.length;
                        lineNum++)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          children: [
                            for (int valNum = 0;
                                valNum <
                                    xDataValueControllers[lineNum].length + 1;
                                valNum++)
                              valNum == 0
                                  ? TitleField(lineTitleControllers[lineNum],
                                      "Line ${lineNum + 1} Name:", () {
                                      setState(() {
                                        chart.data[lineNum].add([0.0, 0.0]);
                                        xDataValueControllers[lineNum]
                                            .add(TextEditingController());
                                        yDataValueControllers[lineNum]
                                            .add(TextEditingController());
                                      });
                                    })
                                  : ValueField(
                                      xDataValueControllers[lineNum]
                                          [valNum - 1],
                                      yDataValueControllers[lineNum]
                                          [valNum - 1], () {
                                      setState(() {
                                        chart.data[lineNum]
                                            .removeAt(valNum - 1);
                                        xDataValueControllers[lineNum]
                                            .removeAt(valNum - 1);
                                        yDataValueControllers[lineNum]
                                            .removeAt(valNum - 1);
                                        if (chart.data[lineNum].isEmpty) {
                                          chart.data.removeAt(lineNum);
                                          xDataValueControllers
                                              .removeAt(lineNum);
                                          yDataValueControllers
                                              .removeAt(lineNum);
                                          lineTitleControllers
                                              .removeAt(lineNum);

                                          options.lineNames.removeAt(lineNum);
                                          options.areGradients
                                              .removeAt(lineNum);
                                          options.lineColors.removeAt(lineNum);
                                          options.lineWidths.removeAt(lineNum);
                                          options.markerStyles
                                              .removeAt(lineNum);
                                          options.markerOutlineColors
                                              .removeAt(lineNum);
                                          options.markerFillColors
                                              .removeAt(lineNum);
                                          options.markerSizes.removeAt(lineNum);
                                          options.markerWidths
                                              .removeAt(lineNum);
                                          options.areaColors1.removeAt(lineNum);
                                          options.areaColors2.removeAt(lineNum);
                                          options.showAreas.removeAt(lineNum);
                                          options.startAlignments
                                              .removeAt(lineNum);
                                          options.endAlignments
                                              .removeAt(lineNum);
                                        }
                                      });
                                    })
                          ],
                        ),
                      ))
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
      decoration: const BoxDecoration(color: Colors.white),
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
            Icons.add_circle_outline,
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
    this.xController,
    this.yController,
    this.callback, {
    super.key,
  });

  final TextEditingController xController;
  final TextEditingController yController;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 0.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: "X Value"),
                  controller: xController,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: "Y Value"),
                  controller: yController,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          IconButton(
            onPressed: callback,
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Color.fromARGB(255, 170, 197, 227),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
