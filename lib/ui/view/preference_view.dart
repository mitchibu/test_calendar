import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/bottom_sheet.dart';

typedef PreferenceStateBuilder = State<StatefulWidget> Function();

abstract class Preference extends StatefulWidget {
  Preference({
    @required this.builder,
    @required this.sharedPreferences,
    @required this.id,
    @required this.title,
  });
  final PreferenceStateBuilder builder;
  final SharedPreferences sharedPreferences;
  final String id;
  final String title;

  @override
  State<StatefulWidget> createState() => builder();

  Widget buildTitle() => Text(title);
  Widget buildSubTitle() => null;
}

class DialogPreference extends Preference {
  DialogPreference({
    @required PreferenceStateBuilder builder,
    @required SharedPreferences sharedPreferences,
    @required String id,
    @required String title,
    this.onTap,
  }) : super(
          builder: builder,
          sharedPreferences: sharedPreferences,
          id: id,
          title: title,
        );
  final GestureTapCallback onTap;
}

class TextPreference extends DialogPreference {
  TextPreference({
    @required SharedPreferences sharedPreferences,
    @required String id,
    @required String title,
    GestureTapCallback onTap,
  }) : super(
          builder: () => _TextPreferenceState(),
          sharedPreferences: sharedPreferences,
          id: id,
          title: title,
          onTap: onTap,
        );

  @override
  Widget buildSubTitle() => Text(sharedPreferences.getString(id) ?? '');
}

class _TextPreferenceState extends State<TextPreference> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => ListTile(
        title: widget.buildTitle(),
        subtitle: widget.buildSubTitle(),
        onTap: () async {
          openModalBottomSheet(
            context: context,
            child: _buildBottomSheet(),
          );
        },
      );

  Widget _buildBottomSheet() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              initialValue: widget.sharedPreferences.getString(widget.id),
              onFieldSubmitted: (data) {
                _done(false);
              },
              onSaved: (data) async {
                print(data);
                await widget.sharedPreferences.setString(widget.id, data);
                setState(() {});
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: RaisedButton(
                    child: Text('Cancel'),
                    color: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () => _done(true),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: RaisedButton(
                    child: Text('ok'),
                    color: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () => _done(false),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  void _done(bool isCancel) {
    if (!isCancel) {
      _formKey.currentState.save();
    }
    Navigator.of(context).pop();
  }
}

class SwitchPreference extends Preference {
  SwitchPreference({
    @required SharedPreferences sharedPreferences,
    @required String id,
    @required String title,
  }) : super(
          builder: () => _SwitchPreferenceState(),
          sharedPreferences: sharedPreferences,
          id: id,
          title: title,
        );
}

class _SwitchPreferenceState extends State<SwitchPreference> {
  @override
  Widget build(BuildContext context) => SwitchListTile(
        title: widget.buildTitle(),
        subtitle: widget.buildSubTitle(),
        value: widget.sharedPreferences.getBool(widget.id) ?? false,
        onChanged: (data) async {
          await widget.sharedPreferences.setBool(widget.id, data);
          setState(() {});
        },
      );
}
