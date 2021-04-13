## 3.0.0

- Support null-safety.
  - BREAKING CHANGE: A new `placeholderWidget` property is supported to display a custom widget while the theme is loaded. It replaces the `withFallback` property. If not specified, it'll display an empty container as before.

## 2.0.0

- Allow management of theme by consumer.
  - BREAKING CHANGE: A new `manager` property that implements `IThemeModeManager` is required.

## 1.0.0

- Initial release.
