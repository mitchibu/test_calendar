import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/preference_view.dart';

typedef PreferenceBuilder = Widget Function(SharedPreferences sp);

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final preferences = <PreferenceBuilder>[
    (sp) => TextPreference(sp, 'key_text', 'text'),
    (sp) => SwitchPreference(sp, 'key_switch', 'switch'),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SafeArea(
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
}
