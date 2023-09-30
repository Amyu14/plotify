
import 'package:flutter/material.dart';

enum ChartStyle { 
  vertical,
  horizontal,
  flipped,
}

enum MultiDataStyle {
  vertical,
  horizontal
}

enum LineChartStyle { sharp, curved }

enum MarkerStyle {none, round, square}

enum ValueStyle { none, round, roundOutlined, square, squareOutlined }

class ChartOptions {
  
  List isMultiColored = [];
  int bgColor = Colors.grey.shade50.value;
  
}

class PieChartOptions extends ChartOptions {
  List sectionWidths = [];
  double sectionsSpacing = 0;
  double offsetAngle = 0;
  List sectionNames = [];
  List sectionColors = [];
  List labelColors = [];
  List freqColors = [];
  List labelOffsets = [];
  List labelFontSizes = [];
  List freqFontSizes = [];
  List labelFontWeights = [];
  List freqFontWeights = [];
  double centerDistance = 0;
  bool showAsPct = false;
  bool includeFreqInLabels = false;
  bool showFreq = false;
  bool showLabels = false;
}
class BarChartOptions extends ChartOptions {
  
  ChartStyle style = ChartStyle.vertical;
  
  MultiDataStyle multiDataStyle = MultiDataStyle.vertical;
  String xLabel = "";
  String yLabel = "";
  int labelColor = Colors.black.value;
  double minY = 0;
  double maxY = 20;
  bool showValueLabels = false;
  int labelBgColor = Colors.grey.shade800.value;
  int labelWeight = 0;
  double verticalGap = 0.1;

  List cumSum = [];

  List chartColors = [];

  bool showGridHori = true;
  double horiGridWidth = 0.5;
  int horiGridColor = Colors.black.value;

  bool showBorder = true;
  double borderWidth = 0.75;
  int borderColor = Colors.black.value;

  bool showXVals = true;
  bool showYVals = true;
  int xValsColor = Colors.black.value;
  int yValsColor = Colors.black.value;

  bool areHorizontalLinesDashed = false;

  int numDivisionsHoriGrid = 6;
  int aspectRatioWidth = 2;
  int aspectRatioHeight = 1;
  double radiusPct = 50;
  double widthPct = 50;

  List groupNames = [];
  List trackNames = [];
}

class LineChartOptions extends ChartOptions {
  
  LineChartStyle style = LineChartStyle.sharp;
  List lineNames = [];

  List lineColors = [];
  List lineWidths = [];
  List markerStyles = [];
  List markerOutlineColors = [];
  List markerFillColors = [];
  List markerSizes = [];
  List markerWidths = [];

  List areaColors1 = [];
  List areaColors2 = [];
  List startAlignments = [];
  List endAlignments = [];
  List showAreas = [];
  List areGradients = [];
  String xLabel = "";
  String yLabel = "";
  int labelColor = Colors.black.value;
  double minX = 0;
  double minY = 0;
  double maxX = 20;
  double maxY = 20;
  bool showGridHori = true;
  double horiGridWidth = 0.5;
  int horiGridColor = Colors.black.value;

  bool showGridVert = true;
  double vertGridWidth = 0.5;
  int vertGridColor = Colors.black.value;

  bool showBorder = true;
  double borderWidth = 0.75;
  int borderColor = Colors.black.value;

  bool showXVals = true;
  bool showYVals = true;
  int xValsColor = Colors.black.value;
  int yValsColor = Colors.black.value;

  int labelWeight = 0;

  bool areVerticalLinesDashed = true;
  bool areHorizontalLinesDashed = true;

  bool showValueLabels = false;
  int labelBgColor = Colors.grey.shade800.value;

  bool labelsAbovePoints = false;

  int numDivisionsHoriGrid = 6;
  int numDivisionsVertGrid = 6;
  int aspectRatioWidth = 2;
  int aspectRatioHeight = 1;

  ChartStyle chartStyle = ChartStyle.vertical;
  ValueStyle valueStyle = ValueStyle.none;
}
