import 'package:flutter/material.dart';

import 'preference.dart';

DialogCreator _creator;

class DialogPreference {
  static void setDialogCreator(DialogCreator creator) {
    _creator = creator;
  }
}

abstract class DialogPreferenceState extends PreferenceState {
  @override
  void onTap(BuildContext context) {
    (_creator ?? DefaultDialogCreator()).show(
        context,
        widget.title,
        buildContent(),
        getNegativeLabel(),
        getNegativeAction(),
        getPositiveLabel(),
        getPositiveAction());
  }

  Widget buildContent();
  String getNegativeLabel() => null;
  VoidCallback getNegativeAction() => null;
  String getPositiveLabel() => null;
  VoidCallback getPositiveAction() => null;
}

abstract class DialogCreator {
  void show(
      BuildContext context,
      String title,
      Widget content,
      String negativeLabel,
      VoidCallback negativeAction,
      String positiveLabel,
      VoidCallback positiveAction);
}

class DefaultDialogCreator extends DialogCreator {
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
      actions.add(
        FlatButton(
          child: Text(negativeLabel),
          onPressed: negativeAction,
        ),
      );
    }
    if (positiveLabel != null) {
      actions.add(
        FlatButton(
          child: Text(positiveLabel),
          onPressed: positiveAction,
        ),
      );
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: title == null ? null : Text(title),
        content: content,
        actions: actions,
      ),
    );
  }
}
