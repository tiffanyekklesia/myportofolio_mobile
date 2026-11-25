# MyPortfolio Mobile

A Flutter portfolio app with education and project forms, public project
listing, Django REST Framework integration, and token-based authentication.

## Setup and run

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

The default API URL is `http://10.0.2.2:8000`, which is reachable from an
Android emulator. For a physical Android device, run:

```powershell
adb reverse tcp:8000 tcp:8000
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

Flutter Web requires the Django backend to allow the local web origin through
CORS.

## Validation

```powershell
dart format .
flutter analyze
flutter test --no-test-assets
```

Generated `*.g.dart` files are ignored by Git and regenerated locally and in CI.
To run on Android, install Android Studio and the Android SDK, then complete
the setup steps reported by `flutter doctor`.

## Tutorial 10 status and backend prerequisite

The Flutter client implements the Tutorial 10 API, project model, public project
list/detail, token login/logout, guarded project creation, and GitHub Actions
CI/APK artifact workflow. The Django project from Tutorial 07 was not included
in this repository, so the backend portion of Tutorial 10 is **not yet applied
or verified**. Before end-to-end testing, apply the backend steps in the
separate Django repository:

- Install `django-cors-headers`; add `corsheaders` and
  `rest_framework.authtoken` to `INSTALLED_APPS`.
- Put `CorsMiddleware` before `CommonMiddleware`, enable
  `TokenAuthentication` before `SessionAuthentication`, add `10.0.2.2` to
  `ALLOWED_HOSTS`, and configure local CORS origins.
- Add `POST /api/v1/auth/token/` and authenticated
  `POST /api/v1/auth/logout/`; migrate the database.
- Keep the Tutorial 07 project endpoints and serializer fields compatible with
  `title`, `description`, `tech_stack`, `project_url`, and optional
  `project_image_url`.

Set the repository Actions variable `API_BASE_URL` to the deployed Django API
root URL (without a trailing slash) to build the APK against deployment. It is
not a secret. Do not store passwords or private tokens in Actions variables.

## AI disclosure

GitHub Copilot in VS Code assisted with interpreting the supplied Tutorial 10
PDF, implementing the Flutter-side API client, model, authentication flow,
project list/detail, CI workflow, tests, and documentation. The prompts
specified the tutorial requirements and requested implementation without
committing or pushing. I reviewed the generated changes against the PDF and
repository structure. The Django backend was not generated because its
Tutorial 07 project is absent; the Flutter client therefore still needs testing
against that backend. AI-generated code can miss runtime, network, CORS, or
environment-specific issues, so local checks and end-to-end testing remain
necessary.

### AI prompting history

- Asked Copilot to read all of Tutorial 10 and apply its requirements without
  committing.
- Clarified that the Django backend repository and deployed API URL were not
  available; proceeded with the Flutter client and CI implementation.
- Earlier prompts covered Assignment 8 navigation, forms, validation,
  documentation, and tests.

### Assignment 8

1. `Navigator.push()` adds a route on top of the current screen, `Navigator.pushReplacement()` replaces the current route, and `Navigator.pop()` removes the current route and returns to the previous one. The Add Education action card uses `Navigator.push()` to open the form while preserving Home underneath. The Home drawer option closes the drawer with `Navigator.pop()` and then uses `Navigator.pushReplacement()` to show Home instead of the form.
2. The `Scaffold` provides the app shell, the `AppBar` keeps the same top bar styling across pages, and the `Drawer` gives a consistent navigation menu on every screen. The same primary color is used for the AppBar and Drawer header on the home screen and education form, so the portfolio theme remains visually consistent.
3. This layout was chosen so the form stays readable and usable on smaller screens. The `SingleChildScrollView` allows the form to scroll when the keyboard is open or when there is limited vertical space, while the padding and spacing keep the fields separated and easy to tap and read.
4. `GlobalKey<FormState>` gives access to the form state, `validator` checks each field before submission, and `validate()` runs the validators when Save is pressed. For example, an empty institution value is rejected because it is required, and a value containing only spaces is not accepted. Simply choosing a `TextFormField` or a keyboard type is not enough because validation logic is still needed to enforce business rules and required data.
