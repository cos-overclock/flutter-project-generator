import 'package:dart_console/dart_console.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_project_generator/model/console_manager/console_manager.dart';
import 'package:flutter_project_generator/model/feature_package/feature_package.dart';

sealed class FlutterFeature {
  late final ConsoleManager manager;

  String get displayText;
  String get name;
  List<FeaturePackage> get packages;
  int _selectIndex;
  bool isSelected;

  FlutterFeature()
      : isSelected = false,
        _selectIndex = 0 {
    manager = GetIt.I.get<ConsoleManager>();
  }

  void toggleSelected() => isSelected = !isSelected;

  FeaturePackage render() {
    _renderCurrentSelection();

    while (true) {
      final key = manager.readKey();
      if (key.controlChar == ControlCharacter.arrowDown) {
        _selectLower();
        _renderCurrentSelection();
      } else if (key.controlChar == ControlCharacter.arrowUp) {
        _selectUpper();
        _renderCurrentSelection();
      } else if (key.controlChar == ControlCharacter.enter) {
        _addSelectedPackageArchive();
        break;
      }
    }

    return packages[_selectIndex];
  }

  void _selectUpper() =>
      _selectIndex = (_selectIndex - 1 + packages.length) % packages.length;

  void _selectLower() => _selectIndex = (_selectIndex + 1) % packages.length;

  void _renderCurrentSelection() {
    manager.renderArchive();
    manager.renderSingleSelect(
      'Select features (use arrow keys to navigate, enter to confirm):',
      packages.map((package) => SingleSelectItem(package.name)).toList(),
      _selectIndex,
    );
  }

  void _addSelectedPackageArchive() {
    String archive = manager.getColorString(
        '$name package selected: ', manager.defaultColor);
    archive += manager.getColorString(
        packages[_selectIndex].name, manager.userPrimaryColor);
    manager.addArchive(archive);
  }
}

class DatabaseFeature extends FlutterFeature {
  DatabaseFeature() : super();

  @override
  String get displayText => 'Database(sqflite, drift, isar ...)';

  @override
  String get name => 'Database';

  @override
  final List<FeaturePackage> packages = [
    DatabasePackage.drift(),
    DatabasePackage.sqlite(),
  ];
}

class LocalStateManagementFeature extends FlutterFeature {
  @override
  String get displayText => 'Local state management(flutter_hooks ...)';

  @override
  String get name => 'LocalStateManagement';

  @override
  final List<FeaturePackage> packages = [];

  LocalStateManagementFeature() : super();
}

class GlobalStateManagementFeature extends FlutterFeature {
  @override
  String get displayText => 'Global state management(provider, riverpod ...)';

  @override
  String get name => 'GlobalStateManagement';

  @override
  final List<FeaturePackage> packages = [];

  GlobalStateManagementFeature() : super();
}

class LoggingFeature extends FlutterFeature {
  @override
  String get displayText => 'Logging(logger, stack_trace ...)';

  @override
  String get name => 'Logging';

  @override
  final List<FeaturePackage> packages = [];

  LoggingFeature() : super();
}

class RoutingFeature extends FlutterFeature {
  @override
  String get displayText => 'Routing(navigation, go_router ...)';

  @override
  String get name => 'Routing';

  @override
  final List<FeaturePackage> packages = [];

  RoutingFeature() : super();
}
