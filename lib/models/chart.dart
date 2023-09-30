import 'package:plotify/models/chart_options.dart';


enum ChartType {
  bar,
  line,
  pie
}


class Chart {
  final int id;
  final String name;
  final DateTime dateAdded;
  DateTime dateChanged;

  final ChartType type;

  final ChartOptions options;
  List data = [];

  Chart({
    required this.id,
    required this.name,
    required this.dateAdded,
    required this.dateChanged,
    required this.type,
    required this.options,
  });
}