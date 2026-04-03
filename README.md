# flutter_forge 🚀

A Bash script that sets up a complete Flutter project in seconds — with folder structure, common packages, Cairo font, state management, RTL support, splash screen, app icon, Firebase, and automatically pushes everything to your GitHub repo.

---

## ✨ What it does

- Creates a new Flutter project with `flutter create`
- Sets up a clean folder structure (`core/`, `features/`, `shared/`)
- Lets you pick your state management: Provider, Bloc, Riverpod, or GetX
- Lets you pick your app language: English, Arabic (RTL), or both
- Lets you pick your primary theme color: Blue, Green, Red, Purple, Orange, or Custom hex
- Configures **Cairo** as the default font for the entire app (light & dark theme)
- Sets up **Splash Screen** using `flutter_native_splash`
- Sets up **App Icon** using `flutter_launcher_icons`
- Optionally adds **Firebase** (Auth, Firestore, Storage, FCM)
- Installs common packages: `dio`, `shared_preferences`, `go_router`, `flutter_svg`, `cached_network_image`, `google_fonts`
- Generates a ready-to-use `main.dart` and `app_theme.dart`
- Creates a new GitHub repository automatically
- Commits and pushes all the starter code to GitHub in one shot

---

## ⚙️ Requirements

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed
- Git installed (`sudo apt install git`)
- curl installed (`sudo apt install curl`)
- A GitHub account
- A GitHub Personal Access Token with `repo` permission
  👉 Generate one at: https://github.com/settings/tokens

---

## 🐧 How to Run (Linux)
```bash
cd ~/Desktop
chmod +x flutter_forge.sh
bash flutter_forge.sh
```

---

## 📌 Usage

The script will ask you these questions:

##📌 Enter your project name (e.g. my_app)
##🏢 Enter your org name (e.g. com.yourname)
##🧠 Choose state management: 1) Provider  2) Bloc  3) Riverpod  4) GetX
##🌐 Choose language: 1) English  2) Arabic (RTL)  3) Both
##🎨 Choose theme color: 1) Blue  2) Green  3) Red  4) Purple  5) Orange  6) Custom hex
##💦 Add Splash Screen? (yes/no)
##🖼️  Add App Icon setup? (yes/no)
##🔥 Add Firebase? (yes/no)
##→ Authentication? Firestore? Storage? Notifications?
##👤 GitHub username
##🔑 GitHub Personal Access Token
##📁 GitHub repo name
##🌐 Public or Private repo?



---

## 📦 Packages Installed

| Package | Purpose |
|---|---|
| `dio` | HTTP / API calls |
| `shared_preferences` | Local storage |
| `go_router` | Navigation |
| `flutter_svg` | SVG support |
| `cached_network_image` | Network images |
| `google_fonts` | Cairo font 🔤 |
| `provider` / `flutter_bloc` / `flutter_riverpod` / `get` | State management (your choice) |
| `flutter_native_splash` | Splash screen (if selected) |
| `flutter_launcher_icons` | App icon (if selected) |
| `firebase_core` + services | Firebase (if selected) |
| `flutter_localizations` + `intl` | RTL support (if Arabic selected) |

---

## 🐙 GitHub Integration

The script uses the GitHub API to:
1. Create a new repository under your account
2. Initialize Git in the project folder
3. Commit all the starter code
4. Push to the `main` branch automatically

After running the script your repo will be live at:
`https://github.com/your_username/your_repo_name`

---

## 🔥 Firebase Setup (if selected)

After the script runs, you need to:
1. Go to https://console.firebase.google.com
2. Create a project and add your Android/iOS app
3. Download `google-services.json` and place it in `android/app/`
4. Run: `flutterfire configure`

---

## 🖼️ After Script — Splash & Icon

After placing your images in `assets/images/`:
```bash
# Generate splash screen
flutter pub run flutter_native_splash:create

# Generate app icon
flutter pub run flutter_launcher_icons
```

---

## ⚠️ Important Note about GitHub Token

GitHub no longer accepts passwords for Git operations. You must use a Personal Access Token:

1. Go to https://github.com/settings/tokens
2. Click Generate new token (classic)
3. Enable the `repo` permission
4. Copy the token and paste it when the script asks

---

> Made with by [hazem abdelouakil]
