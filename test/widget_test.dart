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
}
