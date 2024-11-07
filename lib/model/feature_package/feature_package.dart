import 'dart:io';

import 'package:flutter_template/model/project.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_template/model/console_manager/console_manager.dart';

import 'package.dart';

part 'database_package.dart';

sealed class FeaturePackage {
  late final ConsoleManager manager;
  final String name;
  final List<Package> packages;

  void processAddProject();

  FeaturePackage({required this.name, required this.packages}) {
    manager = GetIt.I.get<ConsoleManager>();
  }
}
