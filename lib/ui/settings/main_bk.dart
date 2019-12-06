import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/bottom_sheet.dart';
import '../view/preference_view.dart';

typedef PreferenceBuilder = Widget Function(SharedPreferences sp);

class PreferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  final preferences = <PreferenceBuilder>[
    (sp) => TextPreference(
          sharedPreferences: sp,
          id: 'key_text',
          title: 'text',
        ),
    (sp) => SwitchPreference(
        sharedPreferences: sp, id: 'key_switch', title: 'switch'),
  ];

  @override
  void initState() {
    preferences.add((sp) => ListTile(
          title: Text('Reset'),
          onTap: () {
            sp.clear();
            setState(() {});
          },
        ));
    preferences.add((sp) => ListTile(
          title: Text('Presets'),
          onTap: () {
            openModalBottomSheet(
              context: context,
              child: _buildBottomSheet(),
            );
          },
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(8.0),
          child: _buildBody(),
        ),
      );

  Widget _buildBody() => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) => ListView.builder(
          itemCount: snapshot.connectionState == ConnectionState.done
              ? preferences.length
              : 0,
          itemBuilder: (context, position) =>
              preferences[position](snapshot.data),
        ),
      );

  final presets = [
    Preset('default'),
  ];
  Widget _buildBottomSheet() => ListView.builder(
        itemCount: presets.length,
        itemBuilder: (context, position) => ListTile(
          title: Text(presets[position].title),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      );
}

class Preset {
  Preset(this.title);
  final String title;
}
