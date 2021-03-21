import 'package:flutter/material.dart';

import 'theme_mode_manager_interface.dart';

/// Wrap the management of the functionality and allow the consumer
/// to persist and retrieve the user's preference wherever they want.
class ThemeModeHandler extends StatefulWidget {
  /// Function that runs when themeMode changes.
  final Widget Function(ThemeMode themeMode) builder;

  /// Implementation of IThemeModeManager to load and save the selected value.
  final IThemeModeManager manager;

  /// Default value to be used when shared preference is null.
  final ThemeMode defaultTheme;

  /// While the themeMode is loaded, you can choose to render a different widget.
  /// By default, it'll render an empty container.
  final Widget? placeholderWidget;

  /// Creates a `ThemeModeHandler`.
  const ThemeModeHandler({
    Key? key,
    required this.builder,
    required this.manager,
    this.defaultTheme = ThemeMode.system,
    this.placeholderWidget,
  }) : super(key: key);

  @override
  _ThemeModeHandlerState createState() => _ThemeModeHandlerState();

  /// Access to the closest [ThemeModeHandler] instance to the given context.
  static _ThemeModeHandlerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeModeHandlerState>();
  }
}

class _ThemeModeHandlerState extends State<ThemeModeHandler> {
  late final Future<ThemeMode> _initFuture = _loadThemeMode();
  late ThemeMode _themeMode;

  /// Current selected value.
  ThemeMode get themeMode => _themeMode;

  /// Updates the themeMode and calls `manager.saveThemeMode`.
  Future<void> saveThemeMode(ThemeMode value) async {
    _updateThemeMode(value);
    await widget.manager.saveThemeMode(value.toString());
  }

  Future<ThemeMode> _loadThemeMode() async {
    final value = await widget.manager.loadThemeMode();
    final theme = ThemeMode.values.firstWhere(
      (v) => v.toString() == value,
      orElse: () => widget.defaultTheme,
    );

    _updateThemeMode(theme);
    return theme;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeMode>(
      future: _initFuture,
      builder: (_, snapshot) {
        return snapshot.hasData
            ? widget.builder(_themeMode)
            : widget.placeholderWidget ?? Container();
      },
    );
  }

  void _updateThemeMode(ThemeMode value) {
    setState(() => _themeMode = value);
  }
}
