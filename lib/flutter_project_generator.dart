import 'dart:io';

import 'package:get_it/get_it.dart';

import 'model/console_manager/console_manager.dart';

import 'model/flutter_feature/flutter_feature_selector.dart';
import 'model/project.dart';

final featureSelector = FlutterFeatureSelector();

void render() {
  GetIt.I.registerSingleton<ConsoleManager>(ConsoleManager());
  GetIt.I.registerSingleton<Project>(Project());
  final manager = GetIt.I.get<ConsoleManager>();
  final project = GetIt.I.get<Project>();

  manager.initConsole();

  project.renderInputProjectName();
  project.renderInputOrganization();

  featureSelector.render();

  for (var feature in featureSelector.featureList) {
    if (feature.isSelected) {
      // 選択したパッケージをプロジェクトに追加する
      project.packages.add(feature.render());
    }
  }

  manager.renderArchive();

  // ここからFlutterプロジェクトを生成していく
  final List<String> args = ['create', project.name];
  if (project.org != null) {
    args.add('--org');
    args.add(project.org!);
  }
  args.add('--empty');

  manager.addArchive('Create Flutter Project !!');
  manager.renderArchive();

  final result = Process.runSync('flutter', args, runInShell: true);
  if (result.exitCode != 0) {
    print(result.stderr);
  }

  for (var package in project.packages) {
    package.processAddProject();
  }
}
