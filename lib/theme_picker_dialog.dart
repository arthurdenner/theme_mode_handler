import 'package:flutter/material.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

const themeModeOptions = [
  {'label': 'System', 'value': ThemeMode.system},
  {'label': 'Light', 'value': ThemeMode.light},
  {'label': 'Dark', 'value': ThemeMode.dark},
];

class ThemePickerDialog extends StatelessWidget {
  const ThemePickerDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select a theme mode'),
      children: themeModeOptions.map((option) {
        return SimpleDialogOption(
          onPressed: () => _selectThemeMode(context, option['value']),
          child: Text(option['label']),
        );
      }).toList(),
    );
  }
}

void _selectThemeMode(BuildContext context, ThemeMode value) async {
  ThemeModeHandler.of(context).setThemeMode(value);
  Navigator.pop(context, value);
}

Future<ThemeMode> showThemePickerDialog({@required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => ThemePickerDialog(),
  );
}
