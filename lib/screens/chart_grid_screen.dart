import 'package:flutter/material.dart';
import 'package:plotify/constants.dart';
import 'package:plotify/widgets/chart_grid.dart';

class ChartGridScreen extends StatelessWidget {
  const ChartGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(standardPadding * 0.5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Plotify",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 15,),
              const Expanded(child: ChartGrid()),
            ],
          ),
      )
    );
  }
}