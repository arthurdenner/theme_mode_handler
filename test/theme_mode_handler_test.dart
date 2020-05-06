import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

class ManagerMock extends Mock implements IThemeModeManager {}

final _mock = ManagerMock();

Widget defaultBuilder(ThemeMode themeMode) {
  return MaterialApp(
    themeMode: themeMode,
    darkTheme: ThemeData(
      scaffoldBackgroundColor: Colors.black,
    ),
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
    ),
    home: Builder(builder: (context) {
      return Scaffold(
        body: RaisedButton(
          onPressed: () {
            ThemeModeHandler.of(context).saveThemeMode(
              themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
            );
          },
        ),
      );
    }),
  );
}

void main() {
  Widget buildApp({
    bool withFallback = true,
    Widget Function(ThemeMode) builder = defaultBuilder,
    bool noManager = false,
  }) {
    return ThemeModeHandler(
      withFallback: withFallback,
      manager: noManager ? null : _mock,
      builder: builder,
    );
  }

  group('assertions', () {
    testWidgets('throws if builder is null', (tester) async {
      expect(
        () => tester.pumpWidget(buildApp(builder: null)),
        throwsAssertionError,
      );
    });

    testWidgets('throws if manager is null', (tester) async {
      expect(
        () => tester.pumpWidget(buildApp(noManager: true)),
        throwsAssertionError,
      );
    });
  });

  group('manager', () {
    testWidgets('calls load and set methods only when needed', (tester) async {
      when(_mock.loadThemeMode()).thenAnswer((_) => Future.value(''));
      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.tap(find.byType(RaisedButton));

      verify(_mock.loadThemeMode()).called(1);
      verify(_mock.saveThemeMode(any)).called(1);
    });
  });

  group('withFallback', () {
    testWidgets('renders a Container while loading if true', (tester) async {
      when(_mock.loadThemeMode()).thenAnswer((_) => Future.value(''));
      await tester.pumpWidget(buildApp());

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Scaffold), findsNothing);
      await tester.pump();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('renders its children while loading if false', (tester) async {
      when(_mock.loadThemeMode()).thenAnswer((_) => Future.value(''));
      await tester.pumpWidget(buildApp(withFallback: false));

      expect(find.byType(Scaffold), findsOneWidget);
      await tester.pump();
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('defaultTheme', () {
    testWidgets('behaves properly to ThemeMode.system', (tester) async {
      when(_mock.loadThemeMode()).thenAnswer(
        (_) => Future.value(''),
      );
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final scaffold1 = tester.firstWidget<Material>(find.byType(Material));
      expect(scaffold1.color, Colors.white);

      await tester.tap(find.byType(RaisedButton));
      await tester.pumpAndSettle();

      final scaffold2 = tester.firstWidget<Material>(find.byType(Material));
      expect(scaffold2.color, Colors.black);
    });

    testWidgets('behaves properly to ThemeMode.dark', (tester) async {
      when(_mock.loadThemeMode()).thenAnswer(
        (_) => Future.value('ThemeMode.dark'),
      );
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final scaffold1 = tester.firstWidget<Material>(find.byType(Material));
      expect(scaffold1.color, Colors.black);

      await tester.tap(find.byType(RaisedButton));
      await tester.pumpAndSettle();

      final scaffold2 = tester.firstWidget<Material>(find.byType(Material));
      expect(scaffold2.color, Colors.white);
    });

    testWidgets('behaves properly to ThemeMode.light', (tester) async {
      when(_mock.loadThemeMode()).thenAnswer(
        (_) => Future.value('ThemeMode.light'),
      );
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final scaffold1 = tester.firstWidget<Material>(find.byType(Material));
      expect(scaffold1.color, Colors.white);

      await tester.tap(find.byType(RaisedButton));
      await tester.pumpAndSettle();

      final scaffold2 = tester.firstWidget<Material>(find.byType(Material));
      expect(scaffold2.color, Colors.black);
    });
  });
}
