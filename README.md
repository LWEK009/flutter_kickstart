# flutter_forge 🚀

A Bash script that sets up a complete Flutter project in seconds — with folder structure, common packages, Cairo font pre-configured, and automatically pushes everything to your GitHub repo.

---

## ✨ What it does

- Creates a new Flutter project with `flutter create`
- Sets up a clean folder structure (`core/`, `features/`, `shared/`)
- Installs common packages: `provider`, `dio`, `shared_preferences`, `go_router`, `flutter_svg`, `cached_network_image`, `google_fonts`
- Configures **Cairo** as the default font for the entire app (light & dark theme)
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

---

## 📦 Packages Installed

| Package | Purpose |
|---|---|
| `provider` | State management |
| `dio` | HTTP / API calls |
| `shared_preferences` | Local storage |
| `go_router` | Navigation |
| `flutter_svg` | SVG support |
| `cached_network_image` | Network images |
| `google_fonts` | Cairo font 🔤 |

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

## ⚠️ Important Note about GitHub Token

GitHub no longer accepts passwords for Git operations. You must use a **Personal Access Token**:

1. Go to https://github.com/settings/tokens
2. Click **Generate new token (classic)**
3. Enable the **`repo`** permission
4. Copy the token and paste it when the script asks for it

---

> Made with ❤️ by [Your Name]
