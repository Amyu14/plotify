import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstore/localstore.dart';
import 'package:plotify/models/chart.dart';
import 'package:plotify/models/chart_options.dart';

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

Map<String, Alignment> textToAlignment = {
  for (int i = 0; i < alignmentOptions.length; i++)
    alignmentOptionsText[i]: alignmentOptions[i]
};

Map<Alignment, String> alignmentToText = {
  for (int i = 0; i < alignmentOptions.length; i++)
    alignmentOptions[i]: alignmentOptionsText[i]
};

Map<String, dynamic> pieChartToMap(Chart chart) {
  PieChartOptions options = chart.options as PieChartOptions;

  return {
    "id": chart.id,
    "name": chart.name,
    "dateAdded": chart.dateAdded.microsecondsSinceEpoch,
    "dateChanged": chart.dateChanged.microsecondsSinceEpoch,
    "type": "pie",
    "data": chart.data,
    "bgColor": options.bgColor,
    "sectionWidths": options.sectionWidths,
    "sectionsSpacing": options.sectionsSpacing,
    "offsetAngle": options.offsetAngle,
    "sectionNames": options.sectionNames,
    "sectionColors": options.sectionColors,
    "labelColors": options.labelColors,
    "freqColors": options.freqColors,
    "labelOffsets": options.labelOffsets,
    "labelFontSizes": options.labelFontSizes,
    "freqFontSizes": options.freqFontSizes,
    "labelFontWeights": options.labelFontWeights,
    "freqFontWeights": options.freqFontWeights,
    "centerDistance": options.centerDistance,
    "showAsPct": options.showAsPct,
    "includeFreqInLabels": options.includeFreqInLabels,
    "showFreq": options.showFreq,
    "showLabels": options.showLabels
  };
}

Chart mapToPieChart(Map<String, dynamic> map) {
  PieChartOptions options = PieChartOptions()
  ..bgColor = map["bgColor"]
  ..sectionWidths = map["sectionWidths"]
  ..sectionNames = map["sectionNames"]
  ..offsetAngle = map["offsetAngle"]
  ..sectionsSpacing = map["sectionsSpacing"]
  ..sectionColors = map["sectionColors"]
  ..labelColors = map["labelColors"]
  ..freqColors = map["freqColors"]
  ..labelOffsets = map["labelOffsets"]
  ..labelFontSizes = map["labelFontSizes"]
  ..freqFontSizes = map["freqFontSizes"]
  ..labelFontWeights = map["labelFontWeights"]
  ..freqFontWeights = map["freqFontWeights"]
  ..centerDistance = map["centerDistance"]
  ..showAsPct = map["showAsPct"]
  ..includeFreqInLabels = map["includeFreqInLabels"]
  ..showFreq = map["showFreq"]
  ..showLabels = map["showLabels"];

  return Chart(
      id: map["id"],
      name: map["name"],
      dateAdded: DateTime.fromMicrosecondsSinceEpoch(map["dateAdded"]),
      dateChanged: DateTime.fromMicrosecondsSinceEpoch(map["dateChanged"]),
      type: ChartType.pie,
      options: options)..data = map["data"];
}

Map<String, dynamic> lineChartToMap(Chart chart) {
  LineChartOptions options = chart.options as LineChartOptions;

  return {
    "id": chart.id,
    "name": chart.name,
    "dateAdded": chart.dateAdded.microsecondsSinceEpoch,
    "dateChanged": chart.dateChanged.microsecondsSinceEpoch,
    "type": "line",
    "data": chart.data,
    "bgColor": options.bgColor,
    "isMultiColored": options.isMultiColored,
    "style": options.style.name,
    "lineNames": options.lineNames,
    "lineColors": options.lineColors,
    "lineWidths": options.lineWidths,
    "markerStyles": [
      for (MarkerStyle markerStyle in options.markerStyles) markerStyle.name
    ],
    "markerOutlineColors": options.markerOutlineColors,
    "markerFillColors": options.markerFillColors,
    "markerSizes": options.markerSizes,
    "markerWidths": options.markerWidths,
    "areaColors1": options.areaColors1,
    "areaColors2": options.areaColors2,
    "startAlignments": [
      for (final alignment in options.startAlignments)
        alignmentToText[alignment]
    ],
    "endAlignments": [
      for (final alignment in options.endAlignments) alignmentToText[alignment]
    ],
    "showAreas": options.showAreas,
    "areGradients": options.areGradients,
    "xLabel": options.xLabel,
    "yLabel": options.yLabel,
    "labelColor": options.labelColor,
    "minX": options.minX,
    "minY": options.minY,
    "maxX": options.maxX,
    "maxY": options.maxY,
    "showGridHori": options.showGridHori,
    "horiGridWidth": options.horiGridWidth,
    "horiGridColor": options.horiGridColor,
    "showGridVert": options.showGridVert,
    "vertGridWidth": options.vertGridWidth,
    "vertGridColor": options.vertGridColor,
    "showBorder": options.showBorder,
    "borderWidth": options.borderWidth,
    "borderColor": options.borderColor,
    "showXVals": options.showXVals,
    "showYVals": options.showYVals,
    "labelWeight": options.labelWeight,
    "areVerticalLinesDashed": options.areVerticalLinesDashed,
    "areHorizontalLinesDashed": options.areHorizontalLinesDashed,
    "showValueLabels": options.showValueLabels,
    "labelBgColor": options.labelBgColor,
    "labelsAbovePoints": options.labelsAbovePoints,
    "numDivisionsHoriGrid": options.numDivisionsHoriGrid,
    "numDivisionsVertGrid": options.numDivisionsVertGrid,
    "aspectRatioWidth": options.aspectRatioWidth,
    "aspectRatioHeight": options.aspectRatioHeight,
    "chartStyle": options.chartStyle.name,
    "valueStyle": options.valueStyle.name
  };
}

Chart mapToLineChart(Map<String, dynamic> map) {
  LineChartOptions options = LineChartOptions()
    ..isMultiColored = map["isMultiColored"]
    ..bgColor = map["bgColor"]
    ..style = LineChartStyle.values.firstWhere((element) {
      return element.name == map["style"];
    })
    ..lineNames = map["lineNames"]
    ..lineColors = map["lineColors"]
    ..lineWidths = map["lineWidths"]
    ..markerStyles = [
      for (final stringVal in map["markerStyles"])
        MarkerStyle.values.firstWhere((element) {
          return element.name == stringVal;
        })
    ]
    ..markerOutlineColors = map["markerOutlineColors"]
    ..markerFillColors = map["markerFillColors"]
    ..markerSizes = map["markerSizes"]
    ..markerWidths = map["markerWidths"]
    ..areaColors1 = map["areaColors1"]
    ..areaColors2 = map["areaColors2"]
    ..startAlignments = [
      for (final stringAligment in map["startAlignments"])
        textToAlignment[stringAligment]!
    ]
    ..endAlignments = [
      for (final stringAligment in map["endAlignments"])
        textToAlignment[stringAligment]!
    ]
    ..showAreas = map["showAreas"]
    ..areGradients = map["areGradients"]
    ..xLabel = map["xLabel"]
    ..yLabel = map["yLabel"]
    ..labelColor = map["labelColor"]
    ..minX = map["minX"]
    ..minY = map["minY"]
    ..maxY = map["maxY"]
    ..showGridHori = map["showGridHori"]
    ..horiGridWidth = map["horiGridWidth"]
    ..horiGridColor = map["horiGridColor"]
    ..showGridVert = map["showGridVert"]
    ..vertGridWidth = map["vertGridWidth"]
    ..vertGridColor = map["vertGridColor"]
    ..showBorder = map["showBorder"]
    ..borderWidth = map["borderWidth"]
    ..borderColor = map["borderColor"]
    ..showXVals = map["showXVals"]
    ..showYVals = map["showYVals"]
    ..labelWeight = map["labelWeight"]
    ..areVerticalLinesDashed = map["areVerticalLinesDashed"]
    ..areHorizontalLinesDashed = map["areHorizontalLinesDashed"]
    ..showValueLabels = map["showValueLabels"]
    ..labelBgColor = map["labelBgColor"]
    ..labelsAbovePoints = map["labelsAbovePoints"]
    ..numDivisionsHoriGrid = map["numDivisionsHoriGrid"]
    ..numDivisionsVertGrid = map["numDivisionsVertGrid"]
    ..aspectRatioWidth = map["aspectRatioWidth"]
    ..aspectRatioHeight = map["aspectRatioHeight"]
    ..chartStyle = ChartStyle.values.firstWhere((element) {
      return element.name == map["chartStyle"];
    })
    ..valueStyle = ValueStyle.values.firstWhere((element) {
      return element.name == map["valueStyle"];
    });

  return Chart(
      id: map["id"],
      name: map["name"],
      dateAdded: DateTime.fromMicrosecondsSinceEpoch(map["dateAdded"]),
      dateChanged: DateTime.fromMicrosecondsSinceEpoch(map["dateChanged"]),
      type: ChartType.line,
      options: options)..data = map["data"];
}

Map<String, dynamic> barChartToMap(Chart chart) {
  BarChartOptions options = chart.options as BarChartOptions;

  return {
    "id": chart.id,
    "name": chart.name,
    "dateAdded": chart.dateAdded.microsecondsSinceEpoch,
    "dateChanged": chart.dateChanged.microsecondsSinceEpoch,
    "type": "bar",
    "data": chart.data,
    "isMulticolored": options.isMultiColored,
    "bgColor": options.bgColor,
    "style": options.style.name,
    "multiDataStyle": options.multiDataStyle.name,
    "labelColor": options.labelColor,
    "minY": options.minY,
    "maxY": options.maxY,
    "showValueLabels": options.showValueLabels,
    "labelBgColor": options.labelBgColor,
    "labelWeight": options.labelWeight,
    "verticalGap": options.verticalGap,
    "cumSum": options.cumSum,
    "chartColors": options.chartColors,
    "showGridHori": options.showGridHori,
    "horiGridWidth": options.horiGridWidth,
    "horiGridColor": options.horiGridColor,
    "showBorder": options.showBorder,
    "borderWidth": options.borderWidth,
    "borderColor": options.borderColor,
    "showXVals": options.showXVals,
    "showYVals": options.showYVals,
    "xValsColor": options.xValsColor,
    "yValsColor": options.yValsColor,
    "areHorizontalLinesDashed": options.areHorizontalLinesDashed,
    "numDivisionsHoriGrid": options.numDivisionsHoriGrid,
    "aspectRatioWidth": options.aspectRatioWidth,
    "aspectRatioHeight": options.aspectRatioHeight,
    "radiusPct": options.radiusPct,
    "widthPct": options.widthPct,
    "groupNames": options.groupNames,
    "trackNames": options.trackNames
  };
}

Chart mapToBarChart(Map<String, dynamic> map) {
  BarChartOptions options = BarChartOptions()
    ..style = ChartStyle.values.firstWhere((element) {
      return element.name == map["style"];
    })
    ..multiDataStyle = MultiDataStyle.values.firstWhere((element) {
      return element.name == map["multiDataStyle"];
    })
    ..isMultiColored = map["isMulticolored"]
    ..bgColor = map["bgColor"]
    ..labelColor = map["labelColor"]
    ..minY = map["minY"]
    ..maxY = map["maxY"]
    ..showValueLabels = map["showValueLabels"]
    ..labelBgColor = map["labelBgColor"]
    ..labelWeight = map["labelWeight"]
    ..verticalGap = map["verticalGap"]
    ..cumSum = map["cumSum"]
    ..chartColors = map["chartColors"]
    ..showGridHori = map["showGridHori"]
    ..horiGridWidth = map["horiGridWidth"]
    ..horiGridColor = map["horiGridColor"]
    ..showBorder = map["showBorder"]
    ..borderWidth = map["borderWidth"]
    ..borderColor = map["borderColor"]
    ..showXVals = map["showXVals"]
    ..showYVals = map["showYVals"]
    ..xValsColor = map["xValsColor"]
    ..yValsColor = map["yValsColor"]
    ..areHorizontalLinesDashed = map["areHorizontalLinesDashed"]
    ..numDivisionsHoriGrid = map["numDivisionsHoriGrid"]
    ..aspectRatioWidth = map["aspectRatioWidth"]
    ..aspectRatioHeight = map["aspectRatioHeight"]
    ..radiusPct = map["radiusPct"]
    ..widthPct = map["widthPct"]
    ..groupNames = map["groupNames"]
    ..trackNames = map["trackNames"];

  return Chart(
      id: map["id"],
      name: map["name"],
      dateAdded: DateTime.fromMicrosecondsSinceEpoch(map["dateAdded"]),
      dateChanged: DateTime.fromMicrosecondsSinceEpoch(map["dateChanged"]),
      type: ChartType.bar,
      options: options)
    ..data = map["data"];
}

class ChartsNotifier extends StateNotifier<List<Chart>> {
  ChartsNotifier() : super([]);

  final db = Localstore.instance;

  void deleteChartFromDb(Chart chart) {
    db.collection("charts").doc(chart.id.toString()).delete();
  }

  Future<void> loadItems() async {
    // await db.collection("charts").delete();
    final items = await db.collection("charts").get();
    List<Chart> chartItems = [];
    if (items != null) {
      for (final chartMap in items.values) {
        if (chartMap["type"] == "bar") {
          chartItems.add(mapToBarChart(chartMap));
        } else if (chartMap["type"] == "pie") {
          chartItems.add(mapToPieChart(chartMap));
        } else {
          chartItems.add(mapToLineChart(chartMap));
        }
      }
    }
    state = chartItems;
  }

  Future<void> addBarToDB(Chart chart) async {
    await db
        .collection("charts")
        .doc(chart.id.toString())
        .set(barChartToMap(chart));
  }

  Future<void> addLineToDB(Chart chart) async {
    await db
        .collection("charts")
        .doc(chart.id.toString())
        .set(lineChartToMap(chart));
  }

  Future<void> addPieToDB(Chart chart) async {
    await db
        .collection("charts")
        .doc(chart.id.toString())
        .set(pieChartToMap(chart));
  }

  void addChart(Chart chart) {
    state = [chart, ...state];
  }

  void removeChart(int id) {
    state = [
      for (Chart chart in state)
        if (chart.id != id) chart
    ];
  }
}

final chartsProvider =
    StateNotifierProvider<ChartsNotifier, List<Chart>>((ref) {
  return ChartsNotifier();
});
