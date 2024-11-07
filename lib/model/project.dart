import 'package:flutter_template/model/console_manager/console_manager.dart';
import 'package:get_it/get_it.dart';

import 'feature_package/feature_package.dart';

class Project {
  late final ConsoleManager manager;
  String name;
  String? org;
  final List<FeaturePackage> packages;

  Project()
      : name = '',
        org = null,
        packages = [] {
    manager = GetIt.I.get<ConsoleManager>();
  }

  void renderInputProjectName() {
    manager.renderArchive();

    final String? appName = manager.simpleTextInput(
        'Please enter the project name', 'application_1');

    if (appName == null) {
      name = 'application_1';
    } else {
      name = appName.isNotEmpty ? appName : 'application_1';
    }

    String archive = manager.getColorString(
        'Application name set to: ', manager.defaultColor);
    archive += manager.getColorString(name, manager.userPrimaryColor);

    manager.addArchive(archive);
    manager.renderArchive();
  }

  void renderInputOrganization() {
    manager.renderArchive();

    final String? orgName = manager.simpleTextInput(
        'Please enter the organization name', 'default_org');

    if (orgName != null && orgName.isNotEmpty) {
      org = orgName;
    }

    String archive;
    if (org == null) {
      archive = manager.getColorString(
          'Organization is Flutter default', manager.defaultColor);
    } else {
      archive =
          manager.getColorString('Organization set to: ', manager.defaultColor);
      archive += manager.getColorString(org!, manager.userPrimaryColor);
    }

    manager.addArchive(archive);
    manager.renderArchive();
  }
}
