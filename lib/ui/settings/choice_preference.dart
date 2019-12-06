import 'package:flutter/material.dart';

import 'dialog_preference.dart';

class ChoicePreferenceState extends DialogPreferenceState {
  ChoicePreferenceState(this.items);
  final List<String> items;
  int _value;
  int _chosenValue;

  @override
  void initState() {
    _value = widget.sharedPreferences.getInt(widget.id) ?? -1;
    print('init $_value');
    super.initState();
  }

  @override
  Widget buildSubTitle() => Text('${_value < 0 ? "" : items[_value]}');

  @override
  Widget buildContent() => SizedBox(
        height: 200,
        child: _ChoiceList(_value, items, (int value) {
          _chosenValue = value;
        }),
      );

  @override
  String getNegativeLabel() => 'Cancel';

  @override
  VoidCallback getNegativeAction() => () => Navigator.of(context).pop(0);

  @override
  String getPositiveLabel() => 'OK';

  @override
  VoidCallback getPositiveAction() => () {
        widget.sharedPreferences.setInt(widget.id, _chosenValue);
        setState(() {
          _value = _chosenValue;
        });
        Navigator.of(context).pop(1);
      };
}

typedef OnChosen = void Function(int value);

class _ChoiceList extends StatefulWidget {
  _ChoiceList(this.initialValue, this.items, this.onChosen);
  final int initialValue;
  final List<String> items;
  final OnChosen onChosen;

  @override
  State<StatefulWidget> createState() => _ChoiceListState();
}

class _ChoiceListState extends State<_ChoiceList> {
  int _value;

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (_, position) => ListTile(
          title: Text(widget.items[position]),
          trailing: Icon(_value == position
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked),
          onTap: () {
            print('tap$position');
            setState(() {
              _value = position;
              widget.onChosen(_value);
            });
          },
        ),
      );
}
