import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plotify/constants.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/providers/charts_provider.dart';

class PieChartData extends ConsumerStatefulWidget {
  final int index;
  const PieChartData(this.index, {super.key});

  @override
  ConsumerState<PieChartData> createState() => _PieChartDataState();
}

class _PieChartDataState extends ConsumerState<PieChartData> {
  final List<TextEditingController> sectionNameControllers = [];
  final List<TextEditingController> sectionFrequencyControllers = [];
  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    Chart chart = ref.watch(chartsProvider)[widget.index];
    PieChartOptions options = chart.options as PieChartOptions;

    if (chart.data.isEmpty) {
      chart.data.add(0.0);
      setState(() {
        options.sectionNames.add("");
        options.sectionColors.add(standardColors[0].value);
        options.sectionWidths.add(100.0);
        options.labelFontWeights.add(0);
        options.freqFontWeights.add(0);
        options.labelFontSizes.add(15.0);
        options.freqFontSizes.add(15.0);
        options.labelOffsets.add(145.0);
        options.labelColors.add(Colors.black.value);
        options.freqColors.add(Colors.black.value);
      });
      isInit = true;
    }

    if (isInit) {
      for (int sectionNum = 0;
          sectionNum < options.sectionNames.length;
          sectionNum++) {
        sectionNameControllers.add(
            TextEditingController()..text = options.sectionNames[sectionNum]);
        sectionFrequencyControllers.add(
            TextEditingController()..text = chart.data[sectionNum].toString());
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
                for (int sectionNum = 0; sectionNum < sectionFrequencyControllers.length; sectionNum++) {
                  chart.data[sectionNum] = double.tryParse(sectionFrequencyControllers[sectionNum].text) ?? 0.0;
                  options.sectionNames[sectionNum] = sectionNameControllers[sectionNum].text;
                }
                Navigator.of(context).pop();
              },
              label: const Text("Save and Return"),
              icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Section"),
            onPressed: () {
              setState(() {
                options.sectionNames.add("");
                chart.data.add(0.0);
                sectionFrequencyControllers.add(TextEditingController());
                sectionNameControllers.add(TextEditingController());
                options.sectionColors.add(standardColors[
                    sectionNameControllers.length % standardColors.length].value);
                options.sectionWidths.add(100.0);
                options.labelFontWeights.add(0);
                options.freqFontWeights.add(0);
                options.labelFontSizes.add(15.0);
                options.freqFontSizes.add(15.0);
                options.labelOffsets.add(145.0);
                options.labelColors.add(Colors.black.value);
                options.freqColors.add(Colors.black.value);
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth()
                },
                children: [
                  const TableRow(children: [
                    TableHeader("Section Names"),
                    TableHeader("Section Frequencies")
                  ]),
                  for (int sectionNum = 0;
                      sectionNum < sectionFrequencyControllers.length;
                      sectionNum++)
                    buildTableRow(context, sectionNameControllers[sectionNum],
                        sectionFrequencyControllers[sectionNum], () {
                      setState(() {
                        options.sectionNames.removeAt(sectionNum);
                        chart.data.removeAt(sectionNum);
                        sectionFrequencyControllers.removeAt(sectionNum);
                        sectionNameControllers.removeAt(sectionNum);
                        options.sectionColors.removeAt(sectionNum);
                        options.sectionWidths.removeAt(sectionNum);
                        options.labelFontWeights.removeAt(sectionNum);
                        options.freqFontWeights.removeAt(sectionNum);
                        options.labelFontSizes.removeAt(sectionNum);
                        options.freqFontSizes.removeAt(sectionNum);
                        options.labelOffsets.removeAt(sectionNum);
                        options.labelColors.removeAt(sectionNum);
                        options.freqColors.removeAt(sectionNum);
                      });
                    })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TableRow buildTableRow(
    BuildContext context,
    TextEditingController nameContoller,
    TextEditingController valController,
    void Function() callback) {
  return TableRow(children: [
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 0.3)),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            textAlign: TextAlign.center,
            controller: nameContoller,
          )),
          IconButton(
              onPressed: callback,
              icon: const Icon(
                Icons.remove_circle_outline,
                size: 16,
                color: Color.fromARGB(255, 170, 197, 227),
              ))
        ],
      ),
    ),
    Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 0.3)),
        child: TextFormField(
          textAlign: TextAlign.center,
          controller: valController,
        ))
  ]);
}

class TableHeader extends StatelessWidget {
  final String text;
  const TableHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 0.075,
              spreadRadius: 0.075,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Colors.white),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
