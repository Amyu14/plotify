import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plotify/constants.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';
import 'package:plotify/providers/charts_provider.dart';
import 'package:intl/intl.dart';
import 'package:plotify/screens/chart_screens/bar_chart_screen.dart';
import 'package:plotify/screens/chart_screens/line_chart_screen.dart';
import 'package:plotify/screens/chart_screens/pie_chart_screen.dart';

const colors = [
  Color.fromARGB(255, 148, 196, 247),
  Color.fromARGB(255, 44, 137, 237),
];

class ChartGrid extends ConsumerStatefulWidget {
  const ChartGrid({super.key});

  @override
  ConsumerState createState() => _ChartGridState();
}

class _ChartGridState extends ConsumerState {

  bool isInit = true;

  Widget buildIcon(ChartType type, double size, Color color) {
    switch (type) {
      case ChartType.bar:
        return Icon(
          Icons.bar_chart_rounded,
          size: size,
          color: color,
        );
      case ChartType.line:
        return Icon(
          Icons.stacked_line_chart_rounded,
          size: size,
          color: color,
        );
      case ChartType.pie:
        return Icon(
          Icons.pie_chart_rounded,
          size: size,
          color: color,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isInit) {
      ref.read(chartsProvider.notifier).loadItems().then((value) {
        setState(() {
          isInit = false;
        });
      });
      return const Center(child: CircularProgressIndicator(),);
    }

    final List<Chart> charts = ref.watch(chartsProvider);
    charts.sort((chart1, chart2) {
      return -chart1.dateChanged.compareTo(chart2.dateChanged);
    });
    return charts.isEmpty
        ? Center(
            child: SizedBox(
              height: 350,
              width: 350,
              child: NewChart(ref: ref)),
          )
        : GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 2),
            itemCount: charts.length + 1,
            itemBuilder: (ctx, index) {
              if (index == 0) {
                return NewChart(ref: ref);
              }

              Chart chart = charts[index - 1];

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    ChartType type = chart.type;
                    switch (type) {
                      case (ChartType.bar):
                        return BarChartScreen(index - 1);
                      case (ChartType.line):
                        return LineChartScreen(index - 1);
                      case (ChartType.pie):
                        return PieChartScreen(index - 1);
                    }
                  })).then((value) {
                    setState(() {
                      chart.dateChanged = DateTime.now();
                    });
                  });
                },
                child: buildGridTile(chart, context, colors[index % 2], () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return SimpleDialog(
                          title: const Text(
                            "Delete Item?",
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("No")),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        ref
                                            .read(chartsProvider.notifier)
                                            .removeChart(chart.id);
                                        ref.read(chartsProvider.notifier).deleteChartFromDb(chart);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Yes")),
                                ],
                              ),
                            )
                          ],
                        );
                      });
                }),
              );
            });
  }

  Widget buildGridTile(Chart chart, BuildContext context, Color color,
      void Function() callback) {
    const containerDecoration = BoxDecoration(
      color: Color.fromARGB(255, 248, 249, 250),
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );

    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chart.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: const Color.fromARGB(255, 18, 74, 131)),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 18,
                  color: Color.fromARGB(255, 167, 90, 84),
                ),
                onPressed: callback,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: buildIcon(chart.type, 150, color),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextContainer(
                  containerDecoration,
                  "Date Added: ${DateFormat.yMMMd().format(chart.dateAdded)}",
                  context),
              const SizedBox(
                width: 10,
              ),
              buildTextContainer(
                  containerDecoration,
                  "Date Modified: ${DateFormat.yMMMd().format(chart.dateChanged)}",
                  context)
            ],
          )
        ],
      ),
    );
  }

  Container buildTextContainer(
      BoxDecoration containerDecoration, String text, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: standardPadding * 0.5, vertical: standardPadding * 0.15),
      decoration: containerDecoration,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: const Color.fromARGB(255, 18, 74, 131),
            fontWeight: FontWeight.w700),
      ),
    );
  }
}

class NewChart extends StatelessWidget {
  const NewChart({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return AddChart((chartName, type) {
                if (chartName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a name!")));
                  return;
                }
                ChartOptions options = type == ChartType.bar
                    ? BarChartOptions()
                    : type == ChartType.line
                        ? LineChartOptions()
                        : PieChartOptions();
                Chart newChart = Chart(
                    id: DateTime.now().microsecondsSinceEpoch,
                    dateAdded: DateTime.now(),
                    dateChanged: DateTime.now(),
                    name: chartName,
                    options: options,
                    type: type);
                ref.read(chartsProvider.notifier).addChart(newChart);
                if (type == ChartType.bar) {
                  ref.read(chartsProvider.notifier).addBarToDB(newChart);
                } else if (type == ChartType.pie) {
                  ref.read(chartsProvider.notifier).addPieToDB(newChart);
                } else {
                  ref.read(chartsProvider.notifier).addLineToDB(newChart);
                }
                Navigator.of(context).pop();
              }, TextEditingController());
            });
      },
      child: const Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
            child: Icon(Icons.add_rounded,
                size: 150, color: Color.fromARGB(255, 148, 196, 247))),
      ),
    );
  }
}

class AddChart extends StatefulWidget {
  final void Function(String, ChartType) callback;
  final TextEditingController controller;
  const AddChart(this.callback, this.controller, {super.key});

  @override
  State<AddChart> createState() => _AddChartState();
}

class _AddChartState extends State<AddChart> {
  ChartType type = ChartType.bar;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Add Chart"),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: widget.controller,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(labelText: "Chart Name:"),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RadioListTile(
            title: Row(
              children: const [
                Icon(Icons.bar_chart_rounded),
                SizedBox(
                  width: 12,
                ),
                Text("Bar Chart")
              ],
            ),
            value: ChartType.bar,
            groupValue: type,
            onChanged: (val) {
              setState(() {
                type = val!;
              });
            }),
        RadioListTile(
            title: Row(
              children: const [
                Icon(Icons.line_axis_rounded),
                SizedBox(
                  width: 12,
                ),
                Text("Line Chart")
              ],
            ),
            value: ChartType.line,
            groupValue: type,
            onChanged: (val) {
              setState(() {
                type = val!;
              });
            }),
        RadioListTile(
            title: Row(
              children: const [
                Icon(Icons.pie_chart_rounded),
                SizedBox(
                  width: 12,
                ),
                Text("Pie Chart")
              ],
            ),
            value: ChartType.pie,
            groupValue: type,
            onChanged: (val) {
              setState(() {
                type = val!;
              });
            }),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
              onPressed: () => widget.callback(widget.controller.text, type),
              child: const Text("Create")),
        )
      ],
    );
  }
}
