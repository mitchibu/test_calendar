import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/preference_view.dart';

typedef PreferenceBuilder = Preference Function(SharedPreferences sp);

class SettingsPage extends StatelessWidget {
  final preferences = <PreferenceBuilder>[
    (sp) => TextPreference(sp, 'key_text', 'text'),
    (sp) => SwitchPreference(sp, 'key_switch', 'switch'),
  ];

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
