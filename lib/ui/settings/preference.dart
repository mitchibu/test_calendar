import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'check_preference.dart';
import 'choice_preference.dart';
import 'switch_preference.dart';
import 'text_preference.dart';

typedef PreferenceBuilder = Widget Function(
    SharedPreferences sharedPreferences);
typedef PreferenceStateBuilder = State<StatefulWidget> Function();
typedef OnPreferenceTap = void Function(BuildContext context);

class PreferenceListView extends StatelessWidget {
  PreferenceListView(this.preferences);
  final List<PreferenceBuilder> preferences;

  @override
  Widget build(BuildContext context) => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) => ListView.builder(
            itemCount: snapshot.connectionState == ConnectionState.done
                ? preferences == null ? 0 : preferences.length
                : 0,
            itemBuilder: (context, position) =>
                preferences[position](snapshot.data)),
      );
}

class Preference extends StatefulWidget {
  Preference.category(String title)
      : this._(null, null, title, () => PreferenceCategoryState(), null);

  Preference.none(String title, OnPreferenceTap onPreferenceTap)
      : this._(null, null, title, () => PreferenceState(), onPreferenceTap);

  Preference.text(SharedPreferences sharedPreferences, String id, String title)
      : this._(sharedPreferences, id, title, () => TextPreferenceState(), null);

  Preference.onoff(SharedPreferences sharedPreferences, String id, String title)
      : this._(
            sharedPreferences, id, title, () => SwitchPreferenceState(), null);

  Preference.check(SharedPreferences sharedPreferences, String id, String title)
      : this._(
            sharedPreferences, id, title, () => CheckPreferenceState(), null);

  Preference.choice(SharedPreferences sharedPreferences, String id,
      String title, List<String> items)
      : this._(sharedPreferences, id, title, () => ChoicePreferenceState(items),
            null);

  Preference.custom(SharedPreferences sharedPreferences, String id,
      String title, PreferenceStateBuilder stateBuilder)
      : this._(sharedPreferences, id, title, stateBuilder, null);

  Preference._(this.sharedPreferences, this.id, this.title, this.stateBuilder,
      this.onPreferenceTap);
  final SharedPreferences sharedPreferences;
  final String id;
  final String title;
  final PreferenceStateBuilder stateBuilder;
  final OnPreferenceTap onPreferenceTap;

  @override
  State<StatefulWidget> createState() => stateBuilder();
}

class PreferenceState extends State<Preference> {
  @override
  Widget build(BuildContext context) => ListTile(
        title: buildTitle(),
        subtitle: buildSubTitle(),
        leading: buildLeading(),
        trailing: buildTrailing(),
        onTap: () => (widget.onPreferenceTap ?? onTap)(context),
      );

  Widget buildTitle() => Text(widget.title);
  Widget buildSubTitle() => null;
  Widget buildLeading() => null;
  Widget buildTrailing() => null;
  void onTap(BuildContext context) {}
}

class PreferenceCategoryState extends PreferenceState {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        color: Theme.of(context).primaryColor,
        child: buildTitle(),
      );
}
