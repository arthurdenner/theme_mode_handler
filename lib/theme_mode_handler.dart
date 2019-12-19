import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeModeHandler extends StatefulWidget {
  /// The function that runs when themeMode changes.
  final Widget Function(ThemeMode themeMode) builder;

  /// Default value to be used when shared preference is null.
  final ThemeMode defaultTheme;

  /// Key used to store the selected value.
  final String sharedPreferencesKey;

  /// If the widget should render an empty container while themeMode is null.
  /// This is the recommended behavior.
  ///
  /// themeMode is null while the preference is loaded, therefore,
  /// to prevent a flash effect, you can render an empty container.
  final bool withFallback;

  const ThemeModeHandler({
    Key key,
    @required this.builder,
    this.defaultTheme = ThemeMode.system,
    this.sharedPreferencesKey = 'theme_mode_preference',
    this.withFallback = true,
  }) : super(key: key);

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
    setState(() {
      _themeMode = value;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      widget.sharedPreferencesKey,
      value.toString(),
    );
  }

  Future<ThemeMode> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(widget.sharedPreferencesKey);

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
