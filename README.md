# MyPortfolio Mobile

A Flutter portfolio dashboard with profile information cards, navigation, and a
portfolio form for adding education details.

## Run in Chrome

```powershell
flutter pub get
flutter run -d chrome
```

## Validate

```powershell
flutter analyze
flutter test
```

To run on Android, install Android Studio and the Android SDK, then complete
the setup steps reported by `flutter doctor`.

## AI Disclosure

I used GitHub Copilot in VS Code to review the supplied Assignment 8 checklist,
inspect the existing Flutter app, and help organize the home screen, reusable
action card, and education form navigation. AI assistance also helped prepare
widget tests and refine these answers. I provided the assignment requirements
as the main prompt and asked for changes to stay within that scope. I reviewed
the proposed changes and ran `flutter analyze` and `flutter test`; these checks
do not replace manually trying the app in Chrome or on a phone.

AI output can miss runtime, device-size, and course-prerequisite issues. In
particular, I must still manually check the app flows and ensure Tutorial 09
is completed before its prerequisite deadline.

### AI Prompting History

- Asked Copilot to assess the project against the Assignment 8 checklist and
  prepare the implementation for review without committing or pushing.
- Asked Copilot to verify navigation, form validation, summary-dialog behavior,
  responsive scrolling, documentation, and tests.

### Assignment 8

1. `Navigator.push()` adds a route on top of the current screen, `Navigator.pushReplacement()` replaces the current route, and `Navigator.pop()` removes the current route and returns to the previous one. The Add Education action card uses `Navigator.push()` to open the form while preserving Home underneath. The Home drawer option closes the drawer with `Navigator.pop()` and then uses `Navigator.pushReplacement()` to show Home instead of the form.
2. The `Scaffold` provides the app shell, the `AppBar` keeps the same top bar styling across pages, and the `Drawer` gives a consistent navigation menu on every screen. The same primary color is used for the AppBar and Drawer header on the home screen and education form, so the portfolio theme remains visually consistent.
3. This layout was chosen so the form stays readable and usable on smaller screens. The `SingleChildScrollView` allows the form to scroll when the keyboard is open or when there is limited vertical space, while the padding and spacing keep the fields separated and easy to tap and read.
4. `GlobalKey<FormState>` gives access to the form state, `validator` checks each field before submission, and `validate()` runs the validators when Save is pressed. For example, an empty institution value is rejected because it is required, and a value containing only spaces is not accepted. Simply choosing a `TextFormField` or a keyboard type is not enough because validation logic is still needed to enforce business rules and required data.
