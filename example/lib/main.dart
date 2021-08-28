import 'package:flutter/material.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:theme_mode_handler/theme_picker_dialog.dart';

import './utils/debouncer.dart';
import 'theme_mode_manager.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
      manager: ExampleThemeModeManager(),
      placeholderWidget: Center(
        child: CircularProgressIndicator(),
      ),
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _debouncer = Debouncer(ms: 1000);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _onPlatformBrightnessChange();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ThemeModeHandler.of(context)?.themeMode;

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

  void _onPlatformBrightnessChange() async {
    final currentBrightness = MediaQuery.of(context).platformBrightness;
    print('currentBrightness: $currentBrightness');

    // await ThemeModeHandler.of(context)?.saveThemeMode(
    //   currentBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
    // );
  }
}
