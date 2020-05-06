import 'package:flutter/material.dart';

import 'theme_mode_manager_interface.dart';

class ThemeModeHandler extends StatefulWidget {
  /// Function that runs when themeMode changes.
  final Widget Function(ThemeMode themeMode) builder;

  /// Implementation of IThemeModeManager to load and save the selected value.
  final IThemeModeManager manager;

  /// Default value to be used when shared preference is null.
  final ThemeMode defaultTheme;

  /// If the widget should render an empty container while themeMode is null.
  /// This is the recommended behavior.
  ///
  /// themeMode is null while the preference is loaded, therefore,
  /// to prevent a flash effect, you can render an empty container.
  final bool withFallback;

  const ThemeModeHandler({
    Key key,
    @required this.builder,
    @required this.manager,
    this.defaultTheme = ThemeMode.system,
    this.withFallback = true,
  })  : assert(builder != null),
        assert(manager != null),
        super(key: key);

  @override
  ThemeModeHandlerState createState() => ThemeModeHandlerState();

  static ThemeModeHandlerState of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeModeHandlerState>();
  }
}

class ThemeModeHandlerState extends State<ThemeModeHandler> {
  ThemeMode _themeMode;

  /// Current selected value.
  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _loadThemeMode().then((ThemeMode value) {
      setState(() {
        _themeMode = value;
      });
    });
  }

  Future<void> setThemeMode(ThemeMode value) async {
    setState(() => _themeMode = value);
    await widget.manager.setThemeMode(value.toString());
  }

  Future<ThemeMode> _loadThemeMode() async {
    final value = await widget.manager.loadThemeMode();

    return ThemeMode.values.firstWhere(
      (v) => v.toString() == value,
      orElse: () => widget.defaultTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (themeMode == null && widget.withFallback) {
      return Container();
    }

    return widget.builder(_themeMode);
  }
}
