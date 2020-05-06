/// Interface to be implemented in order
/// to load and save the selected `ThemeMode`.
abstract class IThemeModeManager {
  /// Loads the selected `ThemeMode` as a `String`.
  Future<String> loadThemeMode();

  /// Allows the consumer to save the selected `ThemeMode` as a `String`.
  Future<bool> saveThemeMode(String value);
}
