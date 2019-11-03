import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Container(
        color: Color.fromARGB(255, 255, 0, 0),
        child: Center(
          child: Text('test'),
        ),
      ),
    ),
  );
}
