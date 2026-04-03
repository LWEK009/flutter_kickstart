#!/bin/bash

# ─────────────────────────────────────────────
#  Flutter Forge 🚀
#  Flutter + Cairo Font + Common Packages
#  + GitHub Auto Create & Push
#  Usage: bash flutter_forge.sh
# ─────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════╗"
echo "║     Flutter Forge Script  🚀         ║"
echo "║  Cairo Font + Packages + GitHub      ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── 1. Ask for project info ──────────────────
read -p "📌 Enter your project name (e.g. my_app): " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Project name cannot be empty."
  exit 1
fi

read -p "🏢 Enter your org name (e.g. com.yourname): " ORG_NAME
if [ -z "$ORG_NAME" ]; then
  ORG_NAME="com.example"
fi

# ── 2. Ask for GitHub info ───────────────────
echo ""
echo "🐙 GitHub Setup"
echo "───────────────────────────────────────"
read -p "👤 Enter your GitHub username: " GH_USERNAME

if [ -z "$GH_USERNAME" ]; then
  echo "❌ GitHub username cannot be empty."
  exit 1
fi

read -sp "🔑 Enter your GitHub token (Personal Access Token): " GH_TOKEN
echo ""

read -p "📁 Enter your GitHub repo name (default: $PROJECT_NAME): " REPO_NAME
if [ -z "$REPO_NAME" ]; then
  REPO_NAME="$PROJECT_NAME"
fi

read -p "🌐 Public or Private repo? (public/private, default: private): " REPO_VISIBILITY
if [ -z "$REPO_VISIBILITY" ]; then
  REPO_VISIBILITY="private"
fi

# ── 3. Check requirements ────────────────────
echo ""
echo "🔍 Checking requirements..."

if ! command -v flutter &> /dev/null; then
  echo "❌ Flutter is not installed."
  echo "   Install from: https://flutter.dev/docs/get-started/install"
  exit 1
fi
echo "   ✔ Flutter found"

if ! command -v git &> /dev/null; then
  echo "❌ Git is not installed. Run: sudo apt install git"
  exit 1
fi
echo "   ✔ Git found"

if ! command -v curl &> /dev/null; then
  echo "❌ curl is not installed. Run: sudo apt install curl"
  exit 1
fi
echo "   ✔ curl found"

# ── 4. Create GitHub repo via API ────────────
echo ""
echo "🐙 Creating GitHub repository \"$REPO_NAME\"..."

IS_PRIVATE=$([ "$REPO_VISIBILITY" = "private" ] && echo true || echo false)

API_RESPONSE=$(curl -s -o /tmp/gh_response.json -w "%{http_code}" \
  -H "Authorization: token $GH_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST https://api.github.com/user/repos \
  -d "{
    \"name\": \"$REPO_NAME\",
    \"private\": $IS_PRIVATE,
    \"auto_init\": false,
    \"description\": \"Flutter project created with Flutter Forge 🚀\"
  }")

if [ "$API_RESPONSE" = "201" ]; then
  echo "   ✔ GitHub repo created successfully!"
elif [ "$API_RESPONSE" = "422" ]; then
  echo "   ⚠️  Repo already exists on GitHub, will push to it."
elif [ "$API_RESPONSE" = "401" ]; then
  echo "❌ Invalid GitHub token."
  echo "   💡 Generate a token at: https://github.com/settings/tokens"
  echo "      Make sure to enable: repo (Full control)"
  exit 1
else
  echo "❌ Failed to create repo (HTTP $API_RESPONSE)"
  cat /tmp/gh_response.json
  exit 1
fi

# ── 5. Run flutter create ─────────────────────
echo ""
echo "⏳ Creating Flutter project \"$PROJECT_NAME\"..."

flutter create --org "$ORG_NAME" "$PROJECT_NAME" > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "❌ Flutter create failed."
  exit 1
fi
echo "✅ Project created!"

# ── 6. Create folder structure ───────────────
echo ""
echo "📁 Setting up folder structure..."

mkdir -p "$PROJECT_NAME/lib/core/constants"
mkdir -p "$PROJECT_NAME/lib/core/theme"
mkdir -p "$PROJECT_NAME/lib/core/utils"
mkdir -p "$PROJECT_NAME/lib/core/network"
mkdir -p "$PROJECT_NAME/lib/features"
mkdir -p "$PROJECT_NAME/lib/shared/widgets"
mkdir -p "$PROJECT_NAME/lib/shared/models"

echo "   ✔ Created: core/constants/"
echo "   ✔ Created: core/theme/"
echo "   ✔ Created: core/utils/"
echo "   ✔ Created: core/network/"
echo "   ✔ Created: features/"
echo "   ✔ Created: shared/widgets/"
echo "   ✔ Created: shared/models/"

# ── 7. Add packages ───────────────────────────
echo ""
echo "📦 Adding packages..."

PACKAGES=("provider" "dio" "shared_preferences" "go_router" "flutter_svg" "cached_network_image" "google_fonts")

for PACKAGE in "${PACKAGES[@]}"; do
  printf "   Adding %-30s" "$PACKAGE..."
  flutter pub add "$PACKAGE" --directory "$PROJECT_NAME" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "✔"
  else
    echo "✘ (skipped)"
  fi
done

# ── 8. Run flutter pub get ────────────────────
echo ""
echo "⚙️  Running flutter pub get..."
flutter pub get --directory "$PROJECT_NAME" > /dev/null 2>&1
echo "✅ Done!"

# ── 9. Setup Cairo font + app_theme.dart ──────
echo ""
echo "🔤 Setting up Cairo font..."

cat > "$PROJECT_NAME/lib/core/theme/app_theme.dart" << 'DART'
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      textTheme: GoogleFonts.cairoTextTheme(),
      fontFamily: GoogleFonts.cairo().fontFamily,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
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

# ── 10. Update main.dart ──────────────────────
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
echo "   ✔ Updated: lib/main.dart"
echo "✅ Cairo font is ready!"

# ── 11. Git init and push to GitHub ──────────
echo ""
echo "🐙 Initializing Git and pushing to GitHub..."

cd "$PROJECT_NAME"

git init > /dev/null 2>&1
git add . > /dev/null 2>&1
git commit -m "🚀 Initial commit - Flutter Forge setup" > /dev/null 2>&1
git branch -M main > /dev/null 2>&1
git remote add origin "https://$GH_USERNAME:$GH_TOKEN@github.com/$GH_USERNAME/$REPO_NAME.git"
git push -u origin main > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "   ✔ Code pushed to GitHub successfully!"
else
  echo "   ⚠️  Push failed. Try manually:"
  echo "   cd $PROJECT_NAME && git push -u origin main"
fi

cd ..

# ── 12. Summary ───────────────────────────────
echo ""
echo "╔══════════════════════════════════════╗"
echo "║         Setup Complete! 🎉            ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "📂 Project  : $PROJECT_NAME/"
echo "📦 Packages : ${PACKAGES[*]}"
echo "🔤 Font     : Cairo (via google_fonts)"
echo "🐙 GitHub   : https://github.com/$GH_USERNAME/$REPO_NAME"
echo ""
echo "👉 Next steps:"
echo "   cd $PROJECT_NAME"
echo "   code .           (open in VS Code)"
echo "   flutter run      (run the app)"
echo ""
