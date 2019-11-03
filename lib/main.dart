import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'repo/db.dart';
import 'ui/splash/main.dart';
import 'ui/top/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(context) => FutureProvider<AppModel>(
        builder: (_) async {
          await Future<dynamic>.delayed(Duration(milliseconds: 2000));
          return AppModel(
            packageInfo: await PackageInfo.fromPlatform(),
            databaseRepository: DatabaseRepository(),
          );
        },
        child: Consumer<AppModel>(
          builder: (_, value, __) => _build(value),
        ),
      );

  Widget _build(AppModel model) => MaterialApp(
        title: model == null ? '' : model.packageInfo.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('ja', ''),
        ],
        home: model == null ? SplashPage() : CalendarPage(),
      );
}
