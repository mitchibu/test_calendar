import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';
import 'repo/db.dart';
import 'repo/preference.dart';
import 'ui/splash/main.dart';
import 'ui/top/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(context) => FutureProvider<AppModel>(
        builder: (_) async {
          return AppModel(
            packageInfo: await PackageInfo.fromPlatform(),
            preferenceRepository:
                PreferenceRepository(await SharedPreferences.getInstance()),
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
