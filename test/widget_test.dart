import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('fits the profile cards on a phone-sized screen', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [320.0, 390.0]) {
      tester.view.physicalSize = Size(width, 844);
      await tester.pumpWidget(MyApp(apiClient: _apiClient((_) async => _notFound)));

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('shows portfolio information and action buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: _apiClient((_) async => _notFound)));

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
    expect(find.text('2506546062'), findsOneWidget);
    expect(find.text('Tiffany'), findsOneWidget);
    expect(find.text('PBP E'), findsOneWidget);
    expect(find.text('View Projects'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('loads projects and opens the selected project detail', (
    WidgetTester tester,
  ) async {
    var projectsRequested = false;
    final apiClient = _apiClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/projects/');
      projectsRequested = true;
      return http.Response(
        jsonEncode([_projectJson()]),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    await tester.pumpWidget(MyApp(apiClient: apiClient));
    await tester.tap(find.text('View Projects'));
    await tester.pumpAndSettle();

    expect(projectsRequested, isTrue);
    expect(find.text('Example Project'), findsOneWidget);
    await tester.tap(find.text('Example Project'));
    await tester.pumpAndSettle();

    expect(find.text('Project Details'), findsOneWidget);
    expect(find.text('Description: A sample portfolio project.'), findsOneWidget);
    expect(find.text('Tech Stack: Flutter, Django'), findsOneWidget);
    expect(find.text('Project URL: https://example.com/project'), findsOneWidget);
    expect(find.text('Project image is unavailable.'), findsNothing);
  });

  testWidgets('education action card validates and shows a summary', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MyApp(apiClient: _apiClient((_) async => _notFound)));
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
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('drawer login guard opens project form and Home returns', (
    WidgetTester tester,
  ) async {
    final apiClient = _apiClient((request) async {
      expect(request.url.path, '/api/v1/auth/token/');
      expect(request.method, 'POST');
      return http.Response(jsonEncode({'token': 'test-token'}), 200);
    });

    await tester.pumpWidget(MyApp(apiClient: apiClient));
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    await _enterText(tester, 'login-username-field', 'student');
    await _enterText(tester, 'login-password-field', 'password');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Project Details'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('project form validates and posts Tutorial 07 JSON', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var postedProject = false;
    final apiClient = _apiClient((request) async {
      if (request.url.path == '/api/v1/auth/token/') {
        return http.Response(jsonEncode({'token': 'test-token'}), 200);
      }

      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/projects/');
      expect(request.headers['authorization'], 'Token test-token');
      expect(
        request.headers['content-type'],
        contains('application/json'),
      );
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['title'], 'My Portfolio App');
      expect(body['description'], 'A portfolio app');
      expect(body['tech_stack'], 'Flutter, Dart');
      expect(body['project_url'], 'https://example.com/portfolio');
      expect(body.containsKey('id'), isFalse);
      postedProject = true;
      return http.Response(
        jsonEncode({
          ...body,
          'id': '5c16e0c8-2f04-4fe8-97c4-99f5c29f7f2b',
          'project_image_url': '',
        }),
        201,
      );
    });

    await tester.pumpWidget(MyApp(apiClient: apiClient));
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsWidgets);

    await _enterText(tester, 'login-username-field', 'student');
    await _enterText(tester, 'login-password-field', 'password');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Project Details'), findsOneWidget);

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Title is required.'), findsOneWidget);
    expect(find.text('Description is required.'), findsOneWidget);
    expect(find.text('Tech Stack is required.'), findsOneWidget);
    expect(find.text('Project URL is required.'), findsOneWidget);

    await _enterText(tester, 'project-title-field', '   ');
    await _enterText(tester, 'project-description-field', 'A portfolio app');
    await _enterText(tester, 'project-tech-stack-field', 'Flutter, Dart');
    await _enterText(tester, 'project-url-field', 'not-a-url');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Title is required.'), findsOneWidget);
    expect(find.text('Enter a valid http or https URL.'), findsOneWidget);
    expect(postedProject, isFalse);

    await _enterText(tester, 'project-title-field', 'My Portfolio App');
    await _enterText(tester, 'project-url-field', 'https://example.com/portfolio');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(postedProject, isTrue);
    expect(find.text('Project added successfully!'), findsOneWidget);
    expect(find.text('Title: My Portfolio App'), findsOneWidget);
    expect(find.text('Description: A portfolio app'), findsOneWidget);
    expect(find.text('Tech Stack: Flutter, Dart'), findsOneWidget);
    expect(find.text('Project URL: https://example.com/portfolio'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('project-title-field')))
          .controller!
          .text,
      isEmpty,
    );
  });

  test('Project model maps the API fields and does not post its server id', () {
    final project = Project.fromJson(_projectJson());

    expect(project.id, 'project-id');
    expect(project.title, 'Example Project');
    expect(project.techStack, 'Flutter, Django');
    expect(project.projectImageUrl, isEmpty);
    expect(project.toJson(), {
      'title': 'Example Project',
      'description': 'A sample portfolio project.',
      'tech_stack': 'Flutter, Django',
      'project_url': 'https://example.com/project',
      'project_image_url': '',
    });
  });
}

final http.Response _notFound = http.Response('Not found', 404);

ApiClient _apiClient(Future<http.Response> Function(http.Request) handler) {
  return ApiClient(
    client: MockClient(handler),
    baseUrl: 'http://localhost:8000',
  );
}

Map<String, dynamic> _projectJson() {
  return {
    'id': 'project-id',
    'title': 'Example Project',
    'description': 'A sample portfolio project.',
    'tech_stack': 'Flutter, Django',
    'project_url': 'https://example.com/project',
  };
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
