import 'package:flutter/material.dart';

void openModalBottomSheet({
  BuildContext context,
  @required Widget child,
}) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      ),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (context) => Container(
      padding: EdgeInsets.only(
          left: 8,
          top: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Colors.transparent,
      child: child,
    ),
  );
}
