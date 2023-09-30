import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:plotify/constants.dart';

double getAspectRatio(int height, int width, bool isHorizontal) {
  return isHorizontal ? height / width : width / height;
}

Widget buildMarker(Color fillColor, Color borderColor, double width,
    double size, double radius) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: fillColor,
        border: Border.all(
            width: width,
            color: width < 0.05 ? Colors.transparent : borderColor)),
  );
}

Column styleOptionsList(int itemCount, void Function(int) callback, int value,
    List<String> options, BuildContext context,
    {String? dirName}) {
  return Column(
    children: List.generate(itemCount, (index) {
      return InkWell(
        onTap: () => callback(index),
        child: Padding(
          padding: const EdgeInsets.all(standardPadding * 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (value == index)
                Container(
                  padding: const EdgeInsets.all(standardPadding * 0.2),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: dirName != null
                        ? Image.asset(
                            "assets/$dirName/$index.png",
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                )
              else
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: dirName != null
                      ? ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Image.asset("assets/$dirName/$index.png",
                              fit: BoxFit.cover),
                        )
                      : null,
                ),
              const SizedBox(
                height: 10,
              ),
              Text(
                options[index],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: value == index
                        ? Theme.of(context).colorScheme.primary
                        : null),
              )
            ],
          ),
        ),
      );
    }),
  );
}

ListTile buildDropDownTile(String text, bool value, void Function() callback) {
  return ListTile(
    horizontalTitleGap: 0,
    title: Text(text),
    trailing: IconButton(
      icon: Icon(value ? Icons.arrow_drop_up : Icons.arrow_drop_down),
      onPressed: callback,
    ),
  );
}

class AddButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const AddButton(
    this.text,
    this.onPressed, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: Text(text));
  }
}

class TextFieldRow extends StatelessWidget {
  final String leadingText;
  final TextEditingController controller;
  const TextFieldRow(
    this.leadingText,
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LeftPaddedText(leadingText),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            controller: controller,
          ),
        )
      ],
    );
  }
}

class AxisLabels extends StatelessWidget {
  const AxisLabels(
      {super.key,
      required this.xAxisLabel,
      required this.yAxisLabel,
      required this.val,
      required this.callback1,
      required this.callback2,
      required this.callback3});

  final TextEditingController xAxisLabel;
  final TextEditingController yAxisLabel;
  final Color val;
  final void Function(String) callback1;
  final void Function(String) callback2;
  final void Function(Color) callback3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LeftPaddedText(
          "Axis Labels",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const LeftPaddedText("X Axis"),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: TextField(
              onChanged: callback1,
              controller: xAxisLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const LeftPaddedText("Y Axis"),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: TextField(
              controller: yAxisLabel,
              onChanged: callback2,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: -5)),
              style: Theme.of(context).textTheme.bodyMedium,
            ))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const LeftPaddedText("Label Color"),
            const SizedBox(
              width: 16,
            ),
            ColorBoxPicker(color: val, changeColor: callback3)
          ],
        ),
      ],
    );
  }
}

class AspectRatioSelection extends StatelessWidget {
  const AspectRatioSelection(
      {super.key,
      required this.aspRatioWidth,
      required this.aspRatioHeight,
      required this.callback});

  final TextEditingController aspRatioWidth;
  final TextEditingController aspRatioHeight;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LeftPaddedText(
          "Aspect Ratio",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                decoration: const InputDecoration(hintText: "Width"),
                controller: aspRatioWidth,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
              const Text(" : "),
              Expanded(
                  child: TextField(
                decoration: const InputDecoration(hintText: "Height"),
                controller: aspRatioHeight,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
              IconButton(
                  onPressed: callback,
                  icon: Icon(
                    Icons.check,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          ),
        ),
      ],
    );
  }
}

class ViewData extends StatelessWidget {
  final void Function() callback;
  final Color? color;
  final double? elevation;
  const ViewData(
    this.callback, {
    this.color,
    this.elevation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: SizedBox(
          height: 100,
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))
            ),
              color: color ?? const Color.fromARGB(255, 248, 249, 250),
              elevation: elevation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.table_chart,
                    size: 60,
                    color: Color.fromARGB(255, 15, 69, 123),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "View Data",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ))),
    );
  }
}

class TitleAndBackButton extends StatelessWidget {
  const TitleAndBackButton({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
          ),
        )
      ],
    );
  }
}

class SliderRow extends StatelessWidget {
  final String text;
  final int value;
  final void Function(double) callback;
  final double? min;
  final double? max;
  final int? divisions;
  const SliderRow(this.text, this.value, this.callback,
      {super.key, this.min, this.max, this.divisions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LeftPaddedText(text),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: min ?? 1,
            max: max ?? 10,
            divisions: divisions ?? 9,
            label: "${value.round()}",
            onChanged: callback,
          ),
        )
      ],
    );
  }
}

class SliderRowDouble extends StatelessWidget {
  final String text;
  final double value;
  final void Function(double) callback;
  final double min;
  final double max;
  final int divisions;
  final Color? color;
  final String? suffix;
  const SliderRowDouble(
      this.text, this.value, this.callback, this.min, this.max, this.divisions,
      {super.key, this.color, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LeftPaddedText(text),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Slider(
            activeColor: color,
            inactiveColor: color,
            thumbColor: color != null ? Theme.of(context).colorScheme.primary : null,
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: suffix == null ? value.toStringAsFixed(1) : value.toStringAsFixed(0) + suffix!,
            onChanged: callback,
          ),
        )
      ],
    );
  }
}

class SliderRowPct extends StatelessWidget {
  final String text;
  final double value;
  final void Function(double) callback;
  final double min;
  final double max;
  final int divisions;
  const SliderRowPct(
      this.text, this.value, this.callback, this.min, this.max, this.divisions,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LeftPaddedText(text),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: "${value.toStringAsFixed(0)}%",
            onChanged: callback,
          ),
        )
      ],
    );
  }
}

class ColorBoxPicker extends StatelessWidget {
  const ColorBoxPicker(
      {super.key, required this.color, required this.changeColor});

  final Color color;
  final void Function(Color) changeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                alignment: Alignment.centerLeft,
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: color,
                    onColorChanged: changeColor,
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Got it'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: SizedBox(
        height: 16,
        width: 16,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
        ),
      ),
    );
  }
}

class CheckBoxOption extends StatelessWidget {
  final String text;
  final bool val;
  final void Function(bool?) callback;
  final TextStyle? style;
  final bool spaceBetween;
  const CheckBoxOption(
    this.text,
    this.val,
    this.callback, {
    this.style,
    this.spaceBetween = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: spaceBetween ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        LeftPaddedText(
          text,
          style: style ?? Theme.of(context).textTheme.titleSmall,
        ),
        if (!spaceBetween) const SizedBox(width: 16,),
        Checkbox(
          value: val,
          onChanged: callback,
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor: Colors.white,
        )
      ],
    );
  }
}

class LeftPaddedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const LeftPaddedText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
