# theme_mode_handler

> This library is considered done - no new features or changes are foreseen.
> You may not see recent updates to this repository, but the library is totally functional.
> Please [open an issue](https://github.com/arthurdenner/theme_mode_handler/issues) if you find an issue
> or think something is missing so we can discuss it.

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![version][version-badge]][package]
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

Flutter widget to change `themeMode` during runtime and persist it across restarts.

## Motivation

Flutter 1.9 introduced a new way to control which theme is used: `MaterialApp.themeMode`. If you have specified the `darkTheme` and `theme` properties, you can use `themeMode` to control it. The property defaults to `ThemeMode.system`.

This package wraps this functionality and allows you to persist and retrieve the user's preference wherever you want by implementing an interface.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  theme_mode_handler: ^3.0.0
```

## Usage

- Create a class that implements the `IThemeModeManager` interface:

```dart
class MyManager implements IThemeModeManager {
  @override
  Future<String> loadThemeMode() async {}

  @override
  Future<bool> saveThemeMode(String value) async {}
}
```

- Import the `ThemeModeHandler` widget, wrap `MaterialApp` with it and pass it an instance of your manager:

```dart
import 'package:theme_mode_handler/theme_mode_handler.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
      manager: MyManager(),
      builder: (ThemeMode themeMode) {
        return MaterialApp(
          themeMode: themeMode,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}
```

- Change the `themeMode` with:

```dart
ThemeModeHandler.of(context).saveThemeMode(value);
```

- Get the current `themeMode` with:

```dart
ThemeModeHandler.of(context).themeMode;
```

Check the `example` folder for a complete example.

## API

### builder

Type: `Widget Function(ThemeMode themeMode)`.

Function that runs when themeMode changes.

### manager

Type: `IThemeModeManager`.

Implementation of IThemeModeManager to load and save the selected value.

#### defaultTheme

Type: `ThemeMode`.

Default value to be used when `manager.loadThemeMode` returns `null` or an invalid value.

### placeholderWidget

Type: `Widget?`.

While the themeMode is loaded, you can choose to render a different widget.
By default, it'll render an empty container.

## Extra

This package exports a dialog and a method to simplify its usage.

- Import the dialog with:

```dart
import 'package:theme_mode_handler/theme_picker_dialog.dart';
```

- Use it like this:

```dart
void _selectThemeMode(BuildContext context) async {
  final newThemeMode = await showThemePickerDialog(context: context);
  print(newThemeMode);
}
```

## Inspiration

This package is inspired and based on the great package [dynamic_theme](https://github.com/Norbert515/dynamic_theme).

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/arthurdenner"><img src="https://avatars0.githubusercontent.com/u/13774309?v=4" width="100px;" alt=""/><br /><sub><b>Arthur Denner</b></sub></a><br /><a href="https://github.com/arthurdenner/theme_mode_handler/commits?author=arthurdenner" title="Code">💻</a> <a href="#design-arthurdenner" title="Design">🎨</a> <a href="#example-arthurdenner" title="Examples">💡</a> <a href="#maintenance-arthurdenner" title="Maintenance">🚧</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## License

MIT © [Arthur Denner](https://github.com/arthurdenner/)

[version-badge]: https://img.shields.io/pub/v/theme_mode_handler?style=flat-square
[package]: https://pub.dev/packages/theme_mode_handler
