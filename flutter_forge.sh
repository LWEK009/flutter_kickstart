#!/bin/bash

# ─────────────────────────────────────────────
#  Flutter Forge 🚀
#  Flutter + Cairo Font + Packages + GitHub
#  + State Management + RTL + Splash + Icon
#  + Theme Color + Firebase
#  Usage: bash flutter_forge.sh
# ─────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║       Flutter Forge Script  🚀           ║"
echo "║  Cairo + Packages + GitHub + Firebase    ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── 1. Project info ──────────────────────────
read -p "📌 Enter your project name (e.g. my_app): " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Project name cannot be empty."
  exit 1
fi

read -p "🏢 Enter your org name (e.g. com.yourname): " ORG_NAME
if [ -z "$ORG_NAME" ]; then
  ORG_NAME="com.example"
fi

# ── 2. State Management ──────────────────────
echo ""
echo "🧠 State Management"
echo "───────────────────────────────────────"
echo "   1) Provider (simple, recommended)"
echo "   2) Bloc (powerful, scalable)"
echo "   3) Riverpod (modern provider)"
echo "   4) GetX (all-in-one)"
read -p "👉 Choose (1-4, default 1): " STATE_CHOICE
case "$STATE_CHOICE" in
  2) STATE_PKG="flutter_bloc" STATE_NAME="Bloc" ;;
  3) STATE_PKG="flutter_riverpod" STATE_NAME="Riverpod" ;;
  4) STATE_PKG="get" STATE_NAME="GetX" ;;
  *) STATE_PKG="provider" STATE_NAME="Provider" ;;
esac
echo "   ✔ Selected: $STATE_NAME"

# ── 3. App Language / RTL ────────────────────
echo ""
echo "🌐 App Language"
echo "───────────────────────────────────────"
echo "   1) English only"
echo "   2) Arabic only (RTL)"
echo "   3) Both English + Arabic"
read -p "👉 Choose (1-3, default 1): " LANG_CHOICE
case "$LANG_CHOICE" in
  2) USE_RTL=true  LANG_NAME="Arabic (RTL)" ;;
  3) USE_RTL=true  LANG_NAME="English + Arabic (RTL)" ;;
  *) USE_RTL=false LANG_NAME="English" ;;
esac
echo "   ✔ Selected: $LANG_NAME"

# ── 4. Theme Color ───────────────────────────
echo ""
echo "🎨 Primary Theme Color"
echo "───────────────────────────────────────"
echo "   1) Blue"
echo "   2) Green"
echo "   3) Red"
echo "   4) Purple"
echo "   5) Orange"
echo "   6) Custom hex (e.g. #FF5733)"
read -p "👉 Choose (1-6, default 1): " COLOR_CHOICE
case "$COLOR_CHOICE" in
  2) THEME_COLOR="Colors.green"   COLOR_NAME="Green" ;;
  3) THEME_COLOR="Colors.red"     COLOR_NAME="Red" ;;
  4) THEME_COLOR="Colors.purple"  COLOR_NAME="Purple" ;;
  5) THEME_COLOR="Colors.orange"  COLOR_NAME="Orange" ;;
  6)
    read -p "   Enter hex color (e.g. FF5733): " HEX_COLOR
    THEME_COLOR="Color(0xFF$HEX_COLOR)"
    COLOR_NAME="Custom (#$HEX_COLOR)"
    ;;
  *) THEME_COLOR="Colors.blue"    COLOR_NAME="Blue" ;;
esac
echo "   ✔ Selected: $COLOR_NAME"

# ── 5. Splash Screen ─────────────────────────
echo ""
read -p "💦 Add Splash Screen? (yes/no, default: yes): " ADD_SPLASH
if [ -z "$ADD_SPLASH" ] || [ "$ADD_SPLASH" = "yes" ] || [ "$ADD_SPLASH" = "y" ]; then
  ADD_SPLASH=true
  echo "   ✔ Splash screen will be added"
else
  ADD_SPLASH=false
  echo "   ✔ Skipping splash screen"
fi

# ── 6. App Icon ──────────────────────────────
read -p "🖼️  Add App Icon setup? (yes/no, default: yes): " ADD_ICON
if [ -z "$ADD_ICON" ] || [ "$ADD_ICON" = "yes" ] || [ "$ADD_ICON" = "y" ]; then
  ADD_ICON=true
  echo "   ✔ App icon setup will be added"
else
  ADD_ICON=false
  echo "   ✔ Skipping app icon"
fi

# ── 7. Firebase ──────────────────────────────
echo ""
read -p "🔥 Add Firebase? (yes/no, default: no): " ADD_FIREBASE
if [ "$ADD_FIREBASE" = "yes" ] || [ "$ADD_FIREBASE" = "y" ]; then
  ADD_FIREBASE=true
  echo "   ✔ Firebase will be added"
  echo ""
  echo "   Which Firebase services do you need?"
  read -p "   Authentication? (yes/no): " FB_AUTH
  read -p "   Firestore Database? (yes/no): " FB_FIRESTORE
  read -p "   Storage? (yes/no): " FB_STORAGE
  read -p "   Push Notifications (FCM)? (yes/no): " FB_FCM
else
  ADD_FIREBASE=false
  echo "   ✔ Skipping Firebase"
fi

# ── 8. GitHub info ───────────────────────────
echo ""
echo "🐙 GitHub Setup"
echo "───────────────────────────────────────"
read -p "👤 Enter your GitHub username: " GH_USERNAME
if [ -z "$GH_USERNAME" ]; then
  echo "❌ GitHub username cannot be empty."
  exit 1
fi

read -sp "🔑 Enter your GitHub Personal Access Token: " GH_TOKEN
echo ""

read -p "📁 GitHub repo name (default: $PROJECT_NAME): " REPO_NAME
if [ -z "$REPO_NAME" ]; then
  REPO_NAME="$PROJECT_NAME"
fi

read -p "🌐 Public or Private? (public/private, default: private): " REPO_VISIBILITY
if [ -z "$REPO_VISIBILITY" ]; then
  REPO_VISIBILITY="private"
fi

# ── 9. Check requirements ────────────────────
echo ""
echo "🔍 Checking requirements..."

if ! command -v flutter &> /dev/null; then
  echo "❌ Flutter not installed → https://flutter.dev/docs/get-started/install"
  exit 1
fi
echo "   ✔ Flutter found"

if ! command -v git &> /dev/null; then
  echo "❌ Git not installed → sudo apt install git"
  exit 1
fi
echo "   ✔ Git found"

if ! command -v curl &> /dev/null; then
  echo "❌ curl not installed → sudo apt install curl"
  exit 1
fi
echo "   ✔ curl found"

# ── 10. Create GitHub repo ───────────────────
echo ""
echo "🐙 Creating GitHub repository \"$REPO_NAME\"..."

IS_PRIVATE=$([ "$REPO_VISIBILITY" = "private" ] && echo true || echo false)

API_RESPONSE=$(curl -s -o /tmp/gh_response.json -w "%{http_code}" \
  -H "Authorization: token $GH_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST https://api.github.com/user/repos \
  -d "{\"name\": \"$REPO_NAME\", \"private\": $IS_PRIVATE, \"auto_init\": false, \"description\": \"Flutter project created with Flutter Forge 🚀\"}")

if [ "$API_RESPONSE" = "201" ]; then
  echo "   ✔ GitHub repo created!"
elif [ "$API_RESPONSE" = "422" ]; then
  echo "   ⚠️  Repo already exists, will push to it."
elif [ "$API_RESPONSE" = "401" ]; then
  echo "❌ Invalid token → https://github.com/settings/tokens"
  exit 1
else
  echo "❌ Failed (HTTP $API_RESPONSE)"
  cat /tmp/gh_response.json
  exit 1
fi

# ── 11. Flutter create ───────────────────────
echo ""
echo "⏳ Creating Flutter project \"$PROJECT_NAME\"..."
flutter create --org "$ORG_NAME" "$PROJECT_NAME" > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "❌ Flutter create failed."; exit 1; fi
echo "✅ Project created!"

# ── 12. Folder structure ─────────────────────
echo ""
echo "📁 Setting up folder structure..."

mkdir -p "$PROJECT_NAME/lib/core/constants"
mkdir -p "$PROJECT_NAME/lib/core/theme"
mkdir -p "$PROJECT_NAME/lib/core/utils"
mkdir -p "$PROJECT_NAME/lib/core/network"
mkdir -p "$PROJECT_NAME/lib/features"
mkdir -p "$PROJECT_NAME/lib/shared/widgets"
mkdir -p "$PROJECT_NAME/lib/shared/models"

echo "   ✔ core/constants/ | core/theme/ | core/utils/ | core/network/"
echo "   ✔ features/ | shared/widgets/ | shared/models/"

# ── 13. Add base packages ────────────────────
echo ""
echo "📦 Adding packages..."

PACKAGES=("dio" "shared_preferences" "go_router" "flutter_svg" "cached_network_image" "google_fonts" "$STATE_PKG")

for PACKAGE in "${PACKAGES[@]}"; do
  printf "   Adding %-35s" "$PACKAGE..."
  flutter pub add "$PACKAGE" --directory "$PROJECT_NAME" > /dev/null 2>&1
  [ $? -eq 0 ] && echo "✔" || echo "✘ (skipped)"
done

# ── 14. RTL / Localization ───────────────────
if [ "$USE_RTL" = true ]; then
  echo ""
  echo "🌐 Setting up RTL + Localization..."
  flutter pub add flutter_localizations --sdk=flutter --directory "$PROJECT_NAME" > /dev/null 2>&1
  flutter pub add intl --directory "$PROJECT_NAME" > /dev/null 2>&1
  echo "   ✔ flutter_localizations added"
  echo "   ✔ intl added"
fi

# ── 15. Splash Screen ────────────────────────
if [ "$ADD_SPLASH" = true ]; then
  echo ""
  echo "💦 Setting up Splash Screen..."
  flutter pub add flutter_native_splash --directory "$PROJECT_NAME" > /dev/null 2>&1
  cat >> "$PROJECT_NAME/pubspec.yaml" << YAML

flutter_native_splash:
  color: "#ffffff"
  image: assets/images/splash.png
  android: true
  ios: true
YAML
  mkdir -p "$PROJECT_NAME/assets/images"
  echo "   ✔ flutter_native_splash added"
  echo "   ✔ Config added to pubspec.yaml"
  echo "   💡 Put your splash image at: assets/images/splash.png"
  echo "   💡 Then run: flutter pub run flutter_native_splash:create"
fi

# ── 16. App Icon ─────────────────────────────
if [ "$ADD_ICON" = true ]; then
  echo ""
  echo "🖼️  Setting up App Icon..."
  flutter pub add flutter_launcher_icons --directory "$PROJECT_NAME" > /dev/null 2>&1
  cat >> "$PROJECT_NAME/pubspec.yaml" << YAML

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
YAML
  mkdir -p "$PROJECT_NAME/assets/images"
  echo "   ✔ flutter_launcher_icons added"
  echo "   ✔ Config added to pubspec.yaml"
  echo "   💡 Put your icon at: assets/images/app_icon.png (1024x1024 px)"
  echo "   💡 Then run: flutter pub run flutter_launcher_icons"
fi

# ── 17. Firebase ─────────────────────────────
if [ "$ADD_FIREBASE" = true ]; then
  echo ""
  echo "🔥 Adding Firebase packages..."
  flutter pub add firebase_core --directory "$PROJECT_NAME" > /dev/null 2>&1
  echo "   ✔ firebase_core added"

  if [ "$FB_AUTH" = "yes" ] || [ "$FB_AUTH" = "y" ]; then
    flutter pub add firebase_auth --directory "$PROJECT_NAME" > /dev/null 2>&1
    echo "   ✔ firebase_auth added"
  fi
  if [ "$FB_FIRESTORE" = "yes" ] || [ "$FB_FIRESTORE" = "y" ]; then
    flutter pub add cloud_firestore --directory "$PROJECT_NAME" > /dev/null 2>&1
    echo "   ✔ cloud_firestore added"
  fi
  if [ "$FB_STORAGE" = "yes" ] || [ "$FB_STORAGE" = "y" ]; then
    flutter pub add firebase_storage --directory "$PROJECT_NAME" > /dev/null 2>&1
    echo "   ✔ firebase_storage added"
  fi
  if [ "$FB_FCM" = "yes" ] || [ "$FB_FCM" = "y" ]; then
    flutter pub add firebase_messaging --directory "$PROJECT_NAME" > /dev/null 2>&1
    echo "   ✔ firebase_messaging added"
  fi
  echo ""
  echo "   ⚠️  Firebase next steps:"
  echo "   1. Go to https://console.firebase.google.com"
  echo "   2. Create a project and add your Android/iOS app"
  echo "   3. Download google-services.json → place in android/app/"
  echo "   4. Run: flutterfire configure"
fi

# ── 18. flutter pub get ──────────────────────
echo ""
echo "⚙️  Running flutter pub get..."
flutter pub get --directory "$PROJECT_NAME" > /dev/null 2>&1
echo "✅ Done!"

# ── 19. app_theme.dart with chosen color ─────
echo ""
echo "🎨 Creating theme with $COLOR_NAME color..."

cat > "$PROJECT_NAME/lib/core/theme/app_theme.dart" << DART
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: $THEME_COLOR),
      useMaterial3: true,
      textTheme: GoogleFonts.cairoTextTheme(),
      fontFamily: GoogleFonts.cairo().fontFamily,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: $THEME_COLOR,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.cairoTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      fontFamily: GoogleFonts.cairo().fontFamily,
    );
  }
}
DART
echo "   ✔ Created: lib/core/theme/app_theme.dart"

# ── 20. main.dart ────────────────────────────
echo "🔤 Writing main.dart..."

if [ "$USE_RTL" = true ]; then
  cat > "$PROJECT_NAME/lib/main.dart" << DART
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$PROJECT_NAME',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const Scaffold(
        body: Center(
          child: Text(
            'مرحباً بك! 🚀',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
DART
else
  cat > "$PROJECT_NAME/lib/main.dart" << DART
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$PROJECT_NAME',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const Scaffold(
        body: Center(
          child: Text(
            'Hello, $PROJECT_NAME! 🚀',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
DART
fi
echo "   ✔ Updated: lib/main.dart"

# ── 21. Git init and push ────────────────────
echo ""
echo "🐙 Pushing to GitHub..."

cd "$PROJECT_NAME"
git init > /dev/null 2>&1
git add . > /dev/null 2>&1
git commit -m "🚀 Initial commit - Flutter Forge setup" > /dev/null 2>&1
git branch -M main > /dev/null 2>&1
git remote add origin "https://$GH_USERNAME:$GH_TOKEN@github.com/$GH_USERNAME/$REPO_NAME.git"
git push -u origin main > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "   ✔ Pushed to GitHub successfully!"
else
  echo "   ⚠️  Push failed. Run manually:"
  echo "   cd $PROJECT_NAME && git push -u origin main"
fi

cd ..

# ── 22. Summary ──────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║           Setup Complete! 🎉              ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "📂 Project        : $PROJECT_NAME/"
echo "🧠 State Mgmt     : $STATE_NAME"
echo "🌐 Language       : $LANG_NAME"
echo "🎨 Theme Color    : $COLOR_NAME"
echo "🔤 Font           : Cairo (google_fonts)"
echo "💦 Splash Screen  : $ADD_SPLASH"
echo "🖼️  App Icon       : $ADD_ICON"
echo "🔥 Firebase       : $ADD_FIREBASE"
echo "🐙 GitHub         : https://github.com/$GH_USERNAME/$REPO_NAME"
echo ""
echo "👉 Next steps:"
echo "   cd $PROJECT_NAME"
echo "   code .              (open in VS Code)"
echo "   flutter run         (run the app)"
if [ "$ADD_SPLASH" = true ]; then
echo "   flutter pub run flutter_native_splash:create   (after adding splash image)"
fi
if [ "$ADD_ICON" = true ]; then
echo "   flutter pub run flutter_launcher_icons         (after adding icon image)"
fi
if [ "$ADD_FIREBASE" = true ]; then
echo "   flutterfire configure                          (after Firebase console setup)"
fi
echo ""
