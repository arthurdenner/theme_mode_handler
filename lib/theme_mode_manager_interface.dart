abstract class IThemeModeManager {
  Future<String> loadThemeMode();
  Future<bool> setThemeMode(String value);
}
