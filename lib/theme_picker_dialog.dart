import 'package:flutter/material.dart';

import 'theme_mode_handler.dart';

class ThemeModeOption {
  final String label;
  final ThemeMode value;

  const ThemeModeOption(this.label, this.value);
}

const _themeModeOptions = [
  ThemeModeOption('System', ThemeMode.system),
  ThemeModeOption('Light', ThemeMode.light),
  ThemeModeOption('Dark', ThemeMode.dark),
];

/// A `SimpleDialog` with `ThemeMode.values` as options.
class ThemePickerDialog extends StatelessWidget {
  /// Creates a `ThemePickerDialog`.
  const ThemePickerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select a theme mode'),
      children: _themeModeOptions.map((option) {
        return SimpleDialogOption(
          onPressed: () => _selectThemeMode(context, option.value),
          child: Text(option.label),
        );
      }).toList(),
    );
  }
}

void _selectThemeMode(BuildContext context, ThemeMode value) async {
  await ThemeModeHandler.of(context)?.saveThemeMode(value);
  Navigator.pop(context, value);
}

/// Displays a `SimpleDialog` with `ThemeMode.values` as options.
Future<ThemeMode?> showThemePickerDialog({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => ThemePickerDialog(),
  );
}
