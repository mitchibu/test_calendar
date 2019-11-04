import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/bottom_sheet.dart';

typedef PreferenceStateBuilder = State<StatefulWidget> Function();

abstract class Preference extends StatefulWidget {
  Preference(this.builder, this.sp, this.id, this.title);
  final PreferenceStateBuilder builder;
  final SharedPreferences sp;
  final String id;
  final String title;

  @override
  State<StatefulWidget> createState() => builder();

  Widget buildTitle() => Text(title);
  Widget buildSubTitle() => null;
}

class TextPreference extends Preference {
  TextPreference(SharedPreferences sp, String id, String title)
      : super(() => _TextPreferenceState(), sp, id, title);

  @override
  Widget buildSubTitle() => Text(sp.getString(id) ?? '');
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
              initialValue: widget.sp.getString(widget.id),
              onFieldSubmitted: (data) {
                _done(false);
              },
              onSaved: (data) async {
                print(data);
                await widget.sp.setString(widget.id, data);
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
  SwitchPreference(SharedPreferences sp, String id, String title)
      : super(() => _SwitchPreferenceState(), sp, id, title);
}

class _SwitchPreferenceState extends State<SwitchPreference> {
  @override
  Widget build(BuildContext context) => SwitchListTile(
        title: widget.buildTitle(),
        subtitle: widget.buildSubTitle(),
        value: widget.sp.getBool(widget.id) ?? false,
        onChanged: (data) async {
          await widget.sp.setBool(widget.id, data);
          setState(() {});
        },
      );
}
