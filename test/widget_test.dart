import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('fits the profile cards on a phone-sized screen', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [320.0, 390.0]) {
      tester.view.physicalSize = Size(width, 844);
      await tester.pumpWidget(const MyApp());

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('shows portfolio information and action buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
    expect(find.text('2506546062'), findsOneWidget);
    expect(find.text('Tiffany'), findsOneWidget);
    expect(find.text('PBP E'), findsOneWidget);
    expect(find.text('View Projects'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('action button shows a SnackBar when tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('View Projects'));
    await tester.pump();

    expect(find.text('You pressed the View Projects button!'), findsOneWidget);
  });

  testWidgets('education action card validates and shows a summary', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byKey(const Key('add-education-action')));
    await tester.pumpAndSettle();

    expect(find.text('Education Details'), findsOneWidget);
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Institution is required.'), findsOneWidget);
    expect(find.text('Degree is required.'), findsOneWidget);
    expect(find.text('Field of study is required.'), findsOneWidget);

    await _enterText(tester, 'institution-field', '   ');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Institution is required.'), findsOneWidget);

    await _enterText(tester, 'institution-field', 'Example University');
    await _enterText(tester, 'degree-field', 'Bachelor');
    await _enterText(tester, 'field-of-study-field', 'Computing');
    final today = DateTime.now().toIso8601String().split('T').first;
    _setControllerText(tester, 'start-date-field', today);
    final earlierDay = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .split('T')
        .first;
    _setControllerText(tester, 'end-date-field', earlierDay);
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      find.text('End date cannot be earlier than start date.'),
      findsOneWidget,
    );

    _setControllerText(tester, 'end-date-field', today);
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Education Summary'), findsOneWidget);
    expect(_summaryLine('Institution', 'Example University'), findsOneWidget);
    expect(_summaryLine('Degree', 'Bachelor'), findsOneWidget);
    expect(_summaryLine('Field of Study', 'Computing'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Education Details'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('drawer opens education form and Home returns to dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Education Details'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });
}

Finder _summaryLine(String label, String value) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is RichText && widget.text.toPlainText() == '$label: $value',
  );
}

Future<void> _enterText(
  WidgetTester tester,
  String fieldKey,
  String value,
) async {
  final field = find.byKey(Key(fieldKey));
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
}

void _setControllerText(WidgetTester tester, String fieldKey, String value) {
  final field = tester.widget<TextFormField>(find.byKey(Key(fieldKey)));
  field.controller!.text = value;
}
