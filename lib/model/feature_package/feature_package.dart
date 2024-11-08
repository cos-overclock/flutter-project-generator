import 'dart:io';

import 'package:get_it/get_it.dart';

import 'package:flutter_project_generator/model/project.dart';
import 'package:flutter_project_generator/model/console_manager/console_manager.dart';

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
