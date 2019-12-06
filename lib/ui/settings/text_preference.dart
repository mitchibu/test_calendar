import 'package:flutter/material.dart';

import 'dialog_preference.dart';

class TextPreferenceState extends DialogPreferenceState {
  final _formKey = GlobalKey<FormState>();

  String _value = '';

  @override
  void initState() {
    _value = widget.sharedPreferences.getString(widget.id) ?? '';
    super.initState();
  }

  @override
  Widget buildSubTitle() => Text(_value);

  @override
  Widget buildContent() => Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _value,
          onSaved: (data) {
            widget.sharedPreferences.setString(widget.id, data);
            setState(() {
              _value = data;
            });
          },
        ),
      );

  @override
  String getNegativeLabel() => 'Cancel';

  @override
  VoidCallback getNegativeAction() => () => Navigator.of(context).pop(0);

  @override
  String getPositiveLabel() => 'OK';

  @override
  VoidCallback getPositiveAction() => () {
        _formKey.currentState.save();
        Navigator.of(context).pop(1);
      };
}
