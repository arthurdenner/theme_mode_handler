import 'package:flutter/material.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:theme_mode_handler/theme_picker_dialog.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
      builder: (ThemeMode themeMode) {
        return MaterialApp(
          themeMode: themeMode,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = ThemeModeHandler.of(context).themeMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ThemeModeHandler Example'),
      ),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(50),
          child: Card(
            child: ListTile(
              onTap: () => _selectThemeMode(context),
              title: Text(themeMode.toString()),
              subtitle: const Text('Tap to select another'),
              trailing: const Icon(Icons.settings),
            ),
          ),
        ),
      ),
    );
  }

  void _selectThemeMode(BuildContext context) async {
    final newThemeMode = await showThemePickerDialog(context: context);
    print(newThemeMode);
  }
}
