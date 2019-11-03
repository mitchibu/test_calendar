import 'package:package_info/package_info.dart';

import 'repo/db.dart';
import 'repo/sample.dart';

class AppModel {
  AppModel({this.packageInfo, this.sampleRepository, this.databaseRepositoty});

  final PackageInfo packageInfo;
  final SampleRepository sampleRepository;
  final DatabaseRepositoty databaseRepositoty;
}
