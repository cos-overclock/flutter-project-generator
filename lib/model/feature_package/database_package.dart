part of 'feature_package.dart';

sealed class DatabasePackage extends FeaturePackage {
  DatabasePackage({required super.name, required super.packages}) : super();

  factory DatabasePackage.drift() => DriftPackage();
  factory DatabasePackage.sqlite() => SqlitePackage();
}

class DriftPackage extends DatabasePackage {
  DriftPackage()
      : super(name: 'drift', packages: [
          Package(name: 'drift', isDevelopment: false),
          Package(name: 'drift_flutter', isDevelopment: false),
          Package(name: 'drift_dev', isDevelopment: true),
          Package(name: 'build_runner', isDevelopment: true)
        ]);

  @override
  void processAddProject() {
    // 必要なパッケージを追加する
    final List<String> args = [
      'pub',
      'add',
      ...packages.map((package) =>
          package.isDevelopment ? 'dev:${package.name}' : package.name)
    ];

    manager.addArchive('Drift package added');
    manager.renderArchive();
    final project = GetIt.I.get<Project>();
    Process.runSync('flutter', args,
        runInShell: true, workingDirectory: project.name);
  }
}

class SqlitePackage extends DatabasePackage {
  SqlitePackage()
      : super(
            name: 'sqflite',
            packages: [Package(name: 'sqflite', isDevelopment: false)]);

  @override
  void processAddProject() {
    // TODO: implement processAddProject
  }
}
