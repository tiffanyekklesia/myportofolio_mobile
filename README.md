# MyPortfolio Mobile

A Flutter portfolio dashboard with profile information cards, navigation, and a
portfolio form for adding education and project details.

## Run in Chrome

```powershell
flutter pub get
flutter run -d chrome
```

## Validate

```powershell
flutter analyze
flutter test --no-test-assets
```

To run on Android, install Android Studio and the Android SDK, then complete
the setup steps reported by `flutter doctor`.

## Tutorial 9

The app demonstrates route navigation with the home action cards and reusable
drawer, plus a project form with required-field validation, a category dropdown,
optional technology and URL fields, a summary dialog, and form reset after
confirmation. The form scrolls on small screens and while the keyboard is open.

Run `flutter test --no-test-assets` to check project form validation,
submission, drawer navigation, and the existing education form behavior. The
current widget tests do not depend on bundled test assets.

## AI Disclosure

I used GitHub Copilot in VS Code to review the supplied Assignment 8 checklist,
inspect the existing Flutter app, and help organize the home screen, reusable
action card, education form navigation, and Tutorial 9 project form. AI
assistance also helped prepare widget tests and refine these answers. I provided
the assignment requirements as the main prompt and asked for changes to stay
within that scope. I reviewed the proposed changes and ran `flutter analyze` and
`flutter test --no-test-assets`; these checks do not replace manually trying
the app in Chrome or on a phone.

AI output can miss runtime and device-size issues. Passing automated checks
does not replace manually trying the app in Chrome or on a phone, or completing
the course's Tutorial 09 submission requirements.

### AI Prompting History

- Asked Copilot to assess the project against the Assignment 8 checklist and
  prepare the implementation for review without committing or pushing.
- Asked Copilot to verify navigation, form validation, summary-dialog behavior,
  responsive scrolling, documentation, and tests.
- Asked Copilot to complete Tutorial 9's Add Project form and navigation without
  committing or pushing.

### Assignment 8

1. `Navigator.push()` menambahkan halaman baru di atas halaman saat ini, `Navigator.pushReplacement()` mengganti halaman saat ini, sedangkan `Navigator.pop()` menutup halaman teratas dan kembali ke halaman sebelumnya. Kartu aksi Add Education menggunakan `Navigator.push()` agar formulir terbuka tanpa menghapus Home dari tumpukan navigasi. Opsi Home di drawer menutup drawer dengan `Navigator.pop()`, lalu menggunakan `Navigator.pushReplacement()` untuk kembali ke halaman Home.
2. `Scaffold` menyediakan struktur utama halaman, `AppBar` menjaga tampilan bagian atas tetap konsisten, dan `Drawer` menyediakan navigasi yang sama di setiap halaman. Contohnya, warna primer tema digunakan pada `AppBar` dan header `Drawer`, baik di halaman Home maupun formulir Education.
3. Tata letak ini dipilih agar formulir tetap mudah dibaca dan digunakan di layar kecil. `SingleChildScrollView` memungkinkan pengguna menggulir formulir ketika ruang vertikal terbatas atau papan ketik terbuka. `Padding` dan `SizedBox` memberi jarak antarbagian agar kolom mudah dibaca dan disentuh.
4. `GlobalKey<FormState>` menyediakan akses ke status formulir, setiap `validator` memeriksa aturan suatu kolom, dan `validate()` menjalankan semua validator saat tombol Save ditekan. Contohnya, nama institusi kosong atau hanya berisi spasi ditolak karena kolom tersebut wajib diisi. Memilih `TextFormField` atau tipe papan ketik saja tidak cukup karena keduanya tidak menegakkan aturan seperti nilai wajib, batas panjang, atau urutan tanggal.
