import 'package:flutter/material.dart';

import 'preference.dart';

class SwitchPreferenceState extends PreferenceState {
  bool _value;

  @override
  void initState() {
    _value = widget.sharedPreferences.getBool(widget.id) ?? false;
    super.initState();
  }

  @override
  Widget buildTrailing() => Switch.adaptive(
        value: _value,
        onChanged: (bool value) {
          widget.sharedPreferences.setBool(widget.id, value);
          setState(() {
            _value = value;
          });
        },
      );

  @override
  void onTap(BuildContext context) {
    widget.sharedPreferences.setBool(widget.id, !_value);
    setState(() {
      _value = !_value;
    });
  }
}
