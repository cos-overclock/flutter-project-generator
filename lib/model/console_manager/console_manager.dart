import 'package:dart_console/dart_console.dart';

class MultiSelectItem {
  final String text;
  final bool isSelected;

  MultiSelectItem(this.text, this.isSelected);
}

class SingleSelectItem {
  final String text;

  SingleSelectItem(this.text);
}

class ConsoleManager {
  final int textColor = 0xE7;
  final int defaultColor = 0x8;
  final int userPrimaryColor = 0xE;

  final _console = Console();
  List<String> archive = [];

  void initConsole() {
    _console.clearScreen();
    _console.resetCursorPosition();
  }

  void addArchive(String text) => archive.add(text);

  void renderArchive() {
    _console.clearScreen();

    if (archive.isEmpty) return;

    for (var i = 0; i < archive.length; i++) {
      _console.writeLine(archive[i]);
    }
  }

  String? simpleTextInput(String prompt, String defaultValue) {
    _console.write(getColorString(prompt, textColor));
    _console.write(getColorString('($defaultValue)', defaultColor));
    _console.write(getColorString(': ', textColor));

    _console.setForegroundExtendedColor(userPrimaryColor);
    final String? input = _console.readLine();
    _console.resetColorAttributes();

    return input;
  }

  void renderMultiSelect(
      String title, List<MultiSelectItem> items, int currentSelect) {
    _console.writeLine(getColorString(title, defaultColor));

    for (var i = 0; i < items.length; i++) {
      final isSelected = i == currentSelect;
      final String check = items[i].isSelected ? '[✓]' : '[ ]';
      _console.writeLine(getColorString('$check ${items[i].text}',
          isSelected ? userPrimaryColor : textColor));
    }
  }

  void renderSingleSelect(
      String title, List<SingleSelectItem> items, int currentSelect) {
    _console.writeLine(getColorString(title, defaultColor));

    for (var i = 0; i < items.length; i++) {
      final isSelected = i == currentSelect;
      _console.writeLine(getColorString(
          items[i].text, isSelected ? userPrimaryColor : textColor));
    }
  }

  Key readKey() => _console.readKey();

  String? readInput() => _console.readLine();

  String getColorString(String prompt, int color) =>
      '\x1b[38;5;${color}m$prompt\x1b[m';
}
