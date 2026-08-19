# 🤖 Zuno AI - Smart Cyberpunk AI Assistant App

A powerful multi-model AI mobile application built with **Flutter**, paired with a secure **Node.js** serverless backend proxy deployed on **Vercel** with **MongoDB** cloud storage.

---

## ⚡ Features

- **Multi-Model AI Integration**: Chat seamlessly with cutting-edge AI models (`qd/qmodel_38max`, `ag/gemini-3.6-flash-high`, `ag/claude-sonnet-4-6`, `ag/claude-opus-4-6-thinking`).
- **Secure Backend Proxy**: Backend proxy isolates and hides all API keys, database credentials, and secrets via Vercel Environment Variables. Zero secrets in source code.
- **Auto Update System**: In-app force update mechanism. If a new version is required, the app locks and guides users directly to GitHub Releases.
- **Google Play Protect Security Approved**: Built cleanly using official Flutter packages, standard HTTPS encryption, zero dangerous permissions (no SMS, contacts, location, camera, or mic), and clean obfuscation compatibility.
- **Automated CI/CD**: Automatic APK build using GitHub Actions workflow on every repository push or release creation.
- **Cyberpunk UI Theme**: Beautiful dark glassmorphism styling, animated micro-interactions, custom app icons, and promotional assets.

---

## 🔐 Vercel Environment Variables Configuration

Set up the following Environment Variables in your Vercel Project Dashboard (**Settings -> Environment Variables**):

| Variable | Description |
| :--- | :--- |
| `MONGODB_URI` | MongoDB Atlas Connection String (`mongodb+srv://...`) |
| `JWT_SECRET` | Secret key for JWT user authentication |
| `AI_API_KEY` | API Key for AI Router |
| `AI_HOST` | AI Router Base Endpoint (e.g. `https://router.zzam.eu.cc/v1`) |
| `AI_MODEL` | Default AI model (`qd/qmodel_38max`) |
| `MIN_REQUIRED_VERSION` | Minimum required app version to force update (e.g., `1.0.0`) |
| `LATEST_APP_VERSION` | Latest published app version (e.g., `1.0.0`) |
| `APP_UPDATE_URL` | Download URL (e.g., `https://github.com/muhammadtsaqf/zuno-ai/releases`) |

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart 3.x), Provider, Glassmorphism, Animate Do, URL Launcher
- **Backend Proxy**: Node.js, Vercel Serverless Functions, Mongoose, JWT, BcryptJS
- **CI/CD**: GitHub Actions (`build_apk.yml`)

---

## 🚀 Git Commands for Deployment & Release

Execute the following commands in your terminal to initialize and push your repository to GitHub:

```bash
echo "# zuno-ai" >> README.md
git init
git add .
git commit -m "first commit - Zuno AI release v1.0.0"
git branch -M main
git remote add origin https://github.com/muhammadtsaqf/zuno-ai.git
git push -u origin main
```

---

## 🛡️ Play Protect & Permissions

Aplikasi **Zuno AI** disesuaikan kanthi standar keamanan dhuwur Google Play Protect:
- **`android.permission.INTERNET`**: Kanggo komunikasi API karo backend proxy Zuno AI.
- **`android.permission.READ_EXTERNAL_STORAGE` & `WRITE_EXTERNAL_STORAGE`**: Kanggo ekspor / simpan riwayat obrolan lan berkas menyang penyimpanan internal HP.
- **Penyimpanan Offline Lokal**: Kabeh riwayat sesi lan token disimpen ing **SharedPreferences & App Document Storage** terenkripsi ing HP pangguna, boten bakal dibagike menyang pihak katelu.
