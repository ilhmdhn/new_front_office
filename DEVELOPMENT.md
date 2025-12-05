# Development Guide - Front Office 2

## 🔥 Hot Reload Issues & Solutions

### Masalah Umum: "Perubahan tidak muncul kecuali flutter clean"

#### Penyebab:
1. **GetIt Singleton** - Dependency injection tidak di-reset saat hot reload
2. **SharedPreferences Cache** - Data preferences di-cache secara static
3. **Bluetooth State** - Listener bluetooth yang persistent
4. **Gradle Cache** - Build cache yang corrupt

---

## 🛠️ Solusi Praktis

### 1. Gunakan Hot Restart (bukan Hot Reload)
- **Hot Reload (r)**: Hanya reload UI, state tetap ada
- **Hot Restart (R)**: Reset state aplikasi **← GUNAKAN INI**

```bash
# Saat running:
flutter run

# Di console:
Press 'r' to hot reload.
Press 'R' to hot restart.  ← TEKAN INI untuk update state!
Press 'q' to quit.
```

### 2. Kapan Perlu Hot Restart vs Clean Build

| Perubahan | Hot Reload (r) | Hot Restart (R) | Clean Build |
|-----------|----------------|-----------------|-------------|
| UI/Widget | ✅ | ✅ | ✅ |
| Text/String | ✅ | ✅ | ✅ |
| Color/Style | ✅ | ✅ | ✅ |
| State/Logic | ❌ | ✅ | ✅ |
| Preferences | ❌ | ⚠️ | ✅ |
| GetIt/DI | ❌ | ⚠️ | ✅ |
| Bluetooth | ❌ | ❌ | ✅ |
| Native Code | ❌ | ❌ | ✅ |
| Dependencies | ❌ | ❌ | ✅ |

**Legend:**
- ✅ = Bekerja dengan baik
- ⚠️ = Kadang bekerja, kadang tidak
- ❌ = Tidak bekerja, perlu yang lebih

---

## 🚀 Quick Commands

### Menggunakan Helper Script
```bash
# Make executable (first time only)
chmod +x dev_helper.sh

# Quick clean
./dev_helper.sh clean

# Full rebuild
./dev_helper.sh rebuild

# Run app
./dev_helper.sh run
```

### Manual Commands
```bash
# Hot Restart di console (paling cepat)
# Jalankan app, lalu tekan 'R'

# Clean build (jika hot restart tidak bekerja)
flutter clean && flutter pub get && flutter run

# Gradle clean (jika ada masalah Android-specific)
cd android && ./gradlew clean && cd .. && flutter run

# Nuclear option (jika semua gagal)
./dev_helper.sh full-reset
```

---

## 📝 Best Practices untuk Development

### 1. Untuk Perubahan UI
```bash
# Cukup hot reload
# Tekan 'r' di console
```

### 2. Untuk Perubahan Logic/State
```bash
# Gunakan hot restart
# Tekan 'R' di console
```

### 3. Untuk Perubahan Printer Settings
```bash
# HARUS restart app atau clean build
flutter clean && flutter run
```

### 4. Untuk Perubahan SharedPreferences
```bash
# Cara 1: Uninstall app dari device (paling clean)
# Cara 2: Clean build
flutter clean && flutter run
```

---

## 🐛 Troubleshooting

### Problem: "Perubahan UI tidak muncul"
**Solusi:**
1. Tekan 'R' untuk hot restart (bukan 'r')
2. Jika masih tidak muncul, stop app dan run ulang
3. Jika masih gagal: `flutter clean && flutter run`

### Problem: "Printer settings tidak update"
**Solusi:**
```bash
# Printer settings tersimpan di SharedPreferences
# Perlu restart app sepenuhnya
flutter run  # stop app lalu run lagi
```

### Problem: "Build error setelah git pull"
**Solusi:**
```bash
./dev_helper.sh rebuild
```

### Problem: "Gradle error / Android build gagal"
**Solusi:**
```bash
./dev_helper.sh gradle-clean
```

### Problem: "Semua solusi di atas gagal"
**Solusi:**
```bash
./dev_helper.sh full-reset
# Tunggu sampai selesai, lalu:
flutter run
```

---

## ⚡ Performance Tips

### 1. Gradle Daemon
Gradle daemon sudah diaktifkan di `gradle.properties` untuk build lebih cepat.

### 2. Parallel Build
Build Android menggunakan parallel processing untuk speed up.

### 3. Build Cache
Gradle caching diaktifkan untuk menghindari rebuild yang tidak perlu.

---

## 🎯 Workflow Recommended

```bash
# Saat mulai development:
flutter run

# Saat mengubah UI (widget, text, color):
# → Tekan 'r' di console

# Saat mengubah logic, state, atau preferences:
# → Tekan 'R' di console

# Saat mengubah printer, bluetooth, atau native code:
# → Stop app (tekan 'q')
# → flutter run (run ulang)

# Jika hot restart tidak bekerja:
# → Stop app
# → ./dev_helper.sh clean
# → flutter run

# Sebelum testing final / sebelum commit:
# → ./dev_helper.sh rebuild
# → flutter run --release
```

---

## 📌 Catatan Penting

1. **Hot Reload (r)** vs **Hot Restart (R)**
   - Hot reload HANYA untuk perubahan UI
   - Hot restart untuk perubahan logic dan state
   - Jangan harap preferences/singleton update dengan hot reload!

2. **SharedPreferences Cache**
   - SharedPreferences di-cache secara static
   - Perubahan preferences perlu restart app
   - Untuk testing preferences baru, uninstall app terlebih dahulu

3. **GetIt Singleton**
   - GetIt singleton tidak di-reset saat hot reload/restart
   - Perubahan di `setupLocator()` perlu rebuild

4. **Bluetooth State**
   - Bluetooth listener tetap active setelah hot reload
   - Perubahan printer settings perlu restart app

---

## 🔧 Advanced Tips

### Clear All Caches
```bash
# Flutter cache
flutter clean
flutter pub cache repair

# Gradle cache
cd android && ./gradlew cleanBuildCache && cd ..

# Android build cache
rm -rf android/.gradle
rm -rf android/app/build

# macOS pod cache (jika ada masalah iOS)
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
```

### Force Reinstall App
```bash
# Uninstall dari device
adb uninstall com.ihp.pos

# Install fresh
flutter run
```

### Check for Issues
```bash
# Flutter doctor
flutter doctor -v

# Analyze code
flutter analyze

# Check dependencies
flutter pub outdated
```

---

## 📞 Need Help?

Jika masalah masih berlanjut:
1. Check error message di console
2. Coba `./dev_helper.sh full-reset`
3. Restart Android Studio / VS Code
4. Restart device / emulator
5. Update Flutter: `flutter upgrade`
