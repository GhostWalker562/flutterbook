// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../flutterbook.dart';
import '../editor/editor.dart';
import '../utils/utils.dart';

abstract class Control<T> {
  Control(this.label, this.value, this.initial, this.description);

  final String description;
  final String label;
  final T initial;
  T value;

  Widget build();
}

abstract class ControlsInterface {
  bool boolean({
    required String label,
    required bool initial,
    String description,
  });

  String text({
    required String label,
    required String initial,
    String description,
  });

  double number({
    required String label,
    required double initial,
    String description,
    double max = 1,
    double min = 0,
  });

  T list<T>({
    required String label,
    required T initial,
    required List<ListItem<T>> list,
    required T value,
    String description,
  });
}

class BoolControl extends Control<bool> {
  BoolControl(String label, bool value, bool initial, String description)
      : super(label, value, initial, description);

  @override
  Widget build() => BoolControlWidget(label, value, initial, description);
}

class BoolControlWidget extends StatefulWidget {
  const BoolControlWidget(
      this.label, this.value, this.initial, this.description,
      {Key? key})
      : super(key: key);

  final String label;
  final bool value;
  final bool initial;
  final String description;

  @override
  _BoolControlWidgetState createState() => _BoolControlWidgetState();
}

class _BoolControlWidgetState extends State<BoolControlWidget> {
  late bool value;

  @override
  void initState() {
    value = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseControlLayout(
      label: widget.label,
      desc: widget.description,
      def: widget.initial.toString(),
      control: Row(
        children: [
          Expanded(child: Text(value.toString())),
          const SizedBox(width: 4),
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CupertinoSwitch(
                value: widget.value,
                activeColor: context.colorScheme.primary,
                onChanged: (val) {
                  context
                      .read<CanvasDelegateProvider>()
                      .storyProvider!
                      .update(widget.label, val);
                  value = val;
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StringControl extends Control<String> {
  StringControl(String label, String value, String initial, String description)
      : super(label, value, initial, description);

  @override
  Widget build() => StringControlWidget(label, value, initial, description);
}

class StringControlWidget extends StatelessWidget {
  const StringControlWidget(
      this.label, this.value, this.initial, this.description,
      {Key? key})
      : super(key: key);

  final String label;
  final String value;
  final String initial;
  final String description;

  @override
  Widget build(BuildContext context) {
    return _BaseControlLayout(
      label: label,
      desc: description,
      def: initial.toString(),
      control: TextFormField(
        initialValue: initial,
        cursorWidth: 1,
        onChanged: (str) => context
            .read<CanvasDelegateProvider>()
            .storyProvider!
            .update(label, str),
        scrollPadding: EdgeInsets.zero,
        decoration: InputDecoration(
          hintText: initial,
          contentPadding: const EdgeInsets.fromLTRB(0, 2, 0, 8),
        ),
      ),
    );
  }
}

class NumberControl extends Control<double> {
  NumberControl(String label, double value, double initial, String description,
      this.min, this.max)
      : super(label, value, initial, description);

  final double min;
  final double max;

  @override
  Widget build() =>
      NumberControlWidget(label, value, initial, description, min, max);
}

class NumberControlWidget extends StatefulWidget {
  const NumberControlWidget(this.label, this.value, this.initial,
      this.description, this.min, this.max,
      {Key? key})
      : super(key: key);

  final String label;
  final double value;
  final double initial;
  final String description;
  final double min;
  final double max;

  @override
  _NumberControlWidgetState createState() => _NumberControlWidgetState();
}

class _NumberControlWidgetState extends State<NumberControlWidget> {
  late double value;

  @override
  void initState() {
    value = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseControlLayout(
      label: widget.label,
      desc: widget.description,
      def: widget.initial.toString(),
      control: Row(
        children: [
          Expanded(child: Text(value.toStringAsFixed(0))),
          const SizedBox(width: 4),
          Expanded(
            flex: 6,
            child: CupertinoSlider(
              value: value,
              min: widget.min,
              max: widget.max,
              onChanged: (val) {
                context
                    .read<CanvasDelegateProvider>()
                    .storyProvider!
                    .update(widget.label, val);
                value = val;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseControlLayout extends StatelessWidget {
  const _BaseControlLayout({
    Key? key,
    required this.label,
    required this.desc,
    required this.def,
    required this.control,
  }) : super(key: key);

  final String label;
  final String desc;
  final String def;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: context.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(desc),
        ),
        Expanded(
          flex: 2,
          child: Text(def),
        ),
        Expanded(
          flex: 2,
          child: control,
        ),
      ],
    );
  }
}

class ListControl<T> extends Control<T> {
  final List<ListItem<T>> list;
  ListControl(String label, T value, T initial, String description, this.list)
      : super(label, value, initial, description);

  @override
  Widget build() =>
      ListControlWidget<T>(label, value, initial, description, list);
}

class ListControlWidget<T> extends StatefulWidget {
  const ListControlWidget(
      this.label, this.value, this.initial, this.description, this.list,
      {Key? key})
      : super(key: key);

  final String label;
  final T value;
  final T initial;
  final String description;
  final List<ListItem<T>> list;

  @override
  State<ListControlWidget<T>> createState() => _ListControlWidgetState<T>();
}

class _ListControlWidgetState<T> extends State<ListControlWidget<T>> {
  late ListItem<T>? value;
  late List<ListItem<T>> listValues;

  @override
  void initState() {
    listValues = widget.list;
    if (widget.list.any((element) => element.title == widget.initial)) {
      value = widget.list
          .firstWhere((element) => element.title == widget.initial);
    } else {
      value = widget.list.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<ListItem<T>>> items = listValues
        .asMap()
        .map((index, name) {
          return MapEntry(
            index,
            DropdownMenuItem<ListItem<T>>(
              value: name,
              child: Text(name.title.toString()),
            ),
          );
        })
        .values
        .toList();

    return _BaseControlLayout(
      label: widget.label,
      desc: widget.description,
      def: widget.initial.toString(),
      control: DropdownButton<ListItem<T>>(
        items: items,
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        value: value,
        onChanged: (ListItem<T>? item) {
          if (item != null) {
            setState(() {
              context
                  .read<CanvasDelegateProvider>()
                  .storyProvider!
                  .update(widget.label, item.value);
              value = item;
            });
          }
        },
      ),
    );
  }
}
