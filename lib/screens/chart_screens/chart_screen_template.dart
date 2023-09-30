import 'package:flutter/material.dart';
import 'package:plotify/constants.dart';

class ChartScreenTemplate extends StatefulWidget {
  final List<Widget> chartConfiguration;
  final Widget chartArea;
  final Color bgColor;
  final VoidCallback? callback1;
  final VoidCallback? callback2;
  const ChartScreenTemplate(
      this.bgColor, this.chartConfiguration, this.chartArea,
      {super.key, this.callback1, this.callback2});

  @override
  State<ChartScreenTemplate> createState() => _ChartScreenTemplateState();
}

class _ChartScreenTemplateState extends State<ChartScreenTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bgColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 450,
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      elevation: 2,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(standardPadding),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.chartConfiguration),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(
                          height: 45,
                          width: 214,
                          child: ElevatedButton.icon(
                              onPressed: widget.callback1 ?? () {},
                              icon: const Icon(Icons.save),
                              label: const Text("Save"))),
                      const SizedBox(width: 6,),
                      SizedBox(
                        width: 214,
                        height: 45,
                          child: ElevatedButton.icon(
                              onPressed: widget.callback2 ?? () {},
                              icon: const Icon(Icons.image),
                              label: const Text("Export")))
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Center(
                child: widget.chartArea,
              ),
            )
          ],
        ),
      ),
    );
  }
}
