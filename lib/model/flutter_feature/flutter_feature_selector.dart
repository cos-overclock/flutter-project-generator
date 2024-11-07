import 'package:dart_console/dart_console.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_template/model/console_manager/console_manager.dart';
import 'package:flutter_template/model/flutter_feature/flutter_feature.dart';

class FlutterFeatureSelector {
  late final ConsoleManager manager;
  final List<FlutterFeature> featureList;
  int _selectIndex;

  FlutterFeatureSelector()
      : featureList = [
          DatabaseFeature(),
          RoutingFeature(),
          LoggingFeature(),
          LocalStateManagementFeature(),
          GlobalStateManagementFeature(),
        ],
        _selectIndex = 0 {
    manager = GetIt.I.get<ConsoleManager>();
  }

  void render() {
    _renderTemplateOptionsSelect();

    while (true) {
      final key = manager.readKey();
      if (key.controlChar == ControlCharacter.arrowDown) {
        _selectLower();
        _renderTemplateOptionsSelect();
      } else if (key.controlChar == ControlCharacter.arrowUp) {
        _selectUpper();
        _renderTemplateOptionsSelect();
      } else if (key.char == ' ') {
        _toggleSelected();
        _renderTemplateOptionsSelect();
      } else if (key.controlChar == ControlCharacter.enter) {
        _addSelectedFeatureArchive();
        break;
      }
    }
  }

  void _selectUpper() => _selectIndex =
      (_selectIndex - 1 + featureList.length) % featureList.length;

  void _selectLower() => _selectIndex = (_selectIndex + 1) % featureList.length;

  void _toggleSelected() => featureList[_selectIndex].toggleSelected();

  void _renderTemplateOptionsSelect() {
    manager.renderArchive();
    manager.renderMultiSelect(
      'Select features (use arrow keys to navigate, space to toggle, enter to confirm):',
      featureList
          .map((feature) =>
              MultiSelectItem(feature.displayText, feature.isSelected))
          .toList(),
      _selectIndex,
    );
  }

  void _addSelectedFeatureArchive() {
    String archive =
        manager.getColorString('Feature selected: ', manager.defaultColor);
    archive += manager.getColorString(
        featureList
            .where((feature) => feature.isSelected)
            .map((feature) => feature.name)
            .toString(),
        manager.userPrimaryColor);
    manager.addArchive(archive);
  }
}
