import 'package:flutter/material.dart';

import '../../util/bottom_sheet.dart';
import 'dialog_preference.dart';
import 'preference.dart';

class BottomSheetDialogCreator extends DialogCreator {
  @override
  void show(
      BuildContext context,
      String title,
      Widget content,
      String negativeLabel,
      VoidCallback negativeAction,
      String positiveLabel,
      VoidCallback positiveAction) {
    final actions = List<Widget>();
    if (negativeLabel != null) {
      actions.add(_buildAction(negativeLabel, negativeAction));
    }
    if (positiveLabel != null) {
      actions.add(_buildAction(positiveLabel, positiveAction));
    }
    openModalBottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.title,
          ),
          content,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: actions,
          ),
        ],
      ),
    );
  }

  Widget _buildAction(String label, VoidCallback action) => Expanded(
        child: FlatButton(
          child: Text(label),
          onPressed: action,
        ),
      );
}

class PreferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PreferencePageState();
}

class PreferencePageState extends State<PreferencePage> {
  @override
  void initState() {
    super.initState();
    DialogPreference.setDialogCreator(BottomSheetDialogCreator());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PreferenceListView([
          (sharedPreferences) => Preference.category('test'),
          (sharedPreferences) =>
              Preference.text(sharedPreferences, 'id_text', 'text'),
          (sharedPreferences) =>
              Preference.onoff(sharedPreferences, 'id_onoff', 'onoff'),
          (sharedPreferences) =>
              Preference.check(sharedPreferences, 'id_check', 'check'),
          (sharedPreferences) =>
              Preference.choice(sharedPreferences, 'id_choice', 'choice', [
                'test1',
                'test2',
                'test3',
              ]),
          (sharedPreferences) => Preference.none('none', (context) {
                setState(() {});
              }),
        ]),
      );
}

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  final test = Map<int, bool>();
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: 3,
        itemBuilder: (_, position) => ExpansionPanelList(
          expansionCallback: (i, b) {
            print('$i $b');
            setState(() {
              test[position] = !b;
            });
          },
          children: <ExpansionPanel>[
            ExpansionPanel(
              headerBuilder: (_, isExpanded) => Container(
                padding: EdgeInsets.all(0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('header$position'),
                ),
              ),
              canTapOnHeader: true,
              body: Column(
                children: <Widget>[
                  Text('body$position'),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {},
                      )
                    ],
                  ),
                ],
              ),
              isExpanded: test[position] ?? true,
            ),
          ],
        ),
      );
}
