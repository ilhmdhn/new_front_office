# 🎯 VS Code Workflow Guide

## Cara Start App dengan VS Code Button

Kalau kamu start app pakai **button di VS Code** (bukan terminal), ini workflow yang JAUH LEBIH MUDAH!

---

## 🚀 Quick Start

### 1️⃣ Start App dengan VS Code Debug Panel

**Pilih salah satu:**

**Cara A: Tekan F5**
```
F5 → Start Debugging (Debug mode)
```

**Cara B: Klik Play Button**
1. Buka Debug Panel (Ctrl+Shift+D atau Cmd+Shift+D di Mac)
2. Pilih "Front Office (Debug)" di dropdown
3. Klik tombol ▶️ (Play button hijau)

**Cara C: Menu Bar**
```
Run → Start Debugging (F5)
```

---

## ✨ **KEUNTUNGAN Pakai VS Code Button:**

### ✅ Auto Hot Reload on Save
```
Edit file → Save (Ctrl+S / Cmd+S) → Otomatis reload!
```
**Tidak perlu tekan 'r' atau 'R' di terminal!** 🎉

### ✅ Debug Toolbar Muncul
Setelah app running, muncul toolbar di atas dengan buttons:
```
[⏸️ Pause] [🔄 Hot Reload] [🔁 Hot Restart] [⏹️ Stop]
```

### ✅ Breakpoints & Debugging
- Klik di sebelah kiri line number untuk set breakpoint
- Inspect variables saat app jalan
- Step through code

---

## 🔄 Workflow Development (VS Code Button)

### **1. Ubah UI (Widget, Text, Warna)**

```
1. Edit file dart
2. Save (Ctrl+S / Cmd+S)
3. ✨ OTOMATIS reload! ✨
```

**Atau manual:** Klik button 🔄 (Hot Reload) di toolbar

---

### **2. Ubah Logic/State/Preferences** ⚠️ PENTING!

Hot reload TIDAK CUKUP untuk logic/state! Harus restart:

**Cara 1: Klik button 🔁 (Hot Restart) di toolbar** ← RECOMMENDED
```
Edit file → Save → Klik 🔁 (Hot Restart)
```

**Cara 2: Command Palette**
```
Cmd+Shift+P (Mac) / Ctrl+Shift+P (Windows)
Ketik: "Flutter: Hot Restart"
Enter
```

**Cara 3: Keyboard Shortcut**
- Tambahkan shortcut di VS Code settings
- Recommended: `Cmd+Shift+R` atau `Ctrl+Shift+R`

---

### **3. Ubah Printer/Bluetooth/Native Code**

Untuk ini HARUS restart app sepenuhnya:

```
1. Stop app (klik ⏹️ di toolbar)
2. Start lagi (tekan F5)
```

---

## 🎨 Visual Guide: Debug Toolbar

Saat app running, toolbar muncul di atas:

```
┌─────────────────────────────────────────────────┐
│  [⏸️] [🔄] [🔁] [⏹️]   Front Office (Debug)    │
└─────────────────────────────────────────────────┘
   │    │    │    │
   │    │    │    └─ Stop app
   │    │    └────── Hot Restart ← UNTUK LOGIC/STATE
   │    └─────────── Hot Reload (auto on save)
   └──────────────── Pause execution
```

---

## ⚙️ Settings yang Sudah Dikonfigurasi

File `.vscode/settings.json` sudah di-setup dengan:

```json
{
  // Auto hot reload saat save
  "dart.flutterHotReloadOnSave": "always",

  // Format otomatis saat save
  "editor.formatOnSave": true,

  // Organize imports otomatis
  "editor.codeActionsOnSave": {
    "source.organizeImports": "explicit"
  }
}
```

**Artinya:**
- ✅ Save file = auto reload (untuk UI)
- ✅ Save file = auto format code
- ✅ Save file = auto organize imports

---

## 📊 Kapan Pakai Apa? (VS Code Edition)

| Perubahan | Auto on Save? | Manual Action |
|-----------|--------------|---------------|
| UI/Widget/Text/Color | ✅ Auto reload | - |
| Logic/State | ❌ Perlu restart | Klik 🔁 |
| Preferences/Settings | ❌ Perlu restart | Klik 🔁 lalu test |
| Printer/Bluetooth | ❌ Perlu stop+start | ⏹️ lalu F5 |
| Dependencies | ❌ Perlu rebuild | ⏹️, clean, F5 |

---

## 🎯 Best Practice

### ✅ DO (Recommended):

```
1. Edit UI → Save → Otomatis reload ✨
2. Edit Logic → Save → Klik 🔁 (Hot Restart)
3. Lihat perubahan di emulator/device
```

### ❌ DON'T (Hindari):

```
❌ Edit logic → Save → Tunggu auto reload
   (Auto reload TIDAK cukup untuk logic!)

❌ Edit banyak file → Save semua → Reload sekali
   (Bisa miss beberapa perubahan)
```

### ✅ Tips Pro:

```
✅ Edit file satu-satu → Save → Test
✅ Gunakan breakpoints untuk debug
✅ Check debug console untuk error
✅ Kalau ragu, klik 🔁 (restart lebih aman!)
```

---

## 🔧 Troubleshooting (VS Code)

### Problem: "Perubahan tidak muncul setelah save"

**Solusi 1:** Klik 🔁 (Hot Restart) di toolbar
```
Kemungkinan perubahan di logic/state, bukan UI murni
```

**Solusi 2:** Stop dan start ulang
```
1. Klik ⏹️ (Stop)
2. Tekan F5 (Start)
```

**Solusi 3:** Clean build
```
1. ⏹️ Stop app
2. Terminal: ./dev_helper.sh clean
3. F5 Start app
```

---

### Problem: "Button play/debug tidak muncul"

**Solusi:**
```
1. Buka Debug Panel: Cmd+Shift+D / Ctrl+Shift+D
2. Pilih "Front Office (Debug)" di dropdown
3. Klik ▶️
```

---

### Problem: "Auto reload tidak bekerja"

**Check settings:**
```
1. Buka settings.json (.vscode/settings.json)
2. Pastikan ada:
   "dart.flutterHotReloadOnSave": "always"
3. Reload VS Code window jika perlu
```

---

### Problem: "App terlalu lambat / memory leak"

**Solusi:** Gunakan Profile/Release mode
```
1. Stop app
2. Debug panel → Pilih "Front Office (Profile)"
3. F5
```

---

## 🎓 Keyboard Shortcuts (Recommended)

Tambahkan di VS Code keyboard shortcuts (`Cmd+K Cmd+S`):

```json
{
  "key": "cmd+shift+r",
  "command": "flutter.hotRestart",
  "when": "debugType == 'dart'"
},
{
  "key": "cmd+r",
  "command": "flutter.hotReload",
  "when": "debugType == 'dart'"
}
```

Setelah itu:
- `Cmd+R` = Hot Reload (UI)
- `Cmd+Shift+R` = Hot Restart (Logic/State)

---

## 📱 Debug Console

Check console di panel bawah untuk:
- ✅ Hot reload/restart messages
- ❌ Error messages
- 📊 Performance metrics
- 🐛 Print statements

```
[DEBUG CONSOLE]
Performing hot reload...
Reloaded 3 of 542 libraries in 1,234ms.
✓ Hot reload succeeded
```

---

## 🚨 Kapan Harus Clean Build?

Pakai clean build jika:
1. ✅ Setelah git pull yang banyak perubahan
2. ✅ Update dependencies di pubspec.yaml
3. ✅ Error aneh yang tidak masuk akal
4. ✅ Hot restart tidak menyelesaikan masalah
5. ✅ Sebelum build release/testing final

```bash
# Stop app terlebih dahulu, lalu:
./dev_helper.sh rebuild
# Kemudian F5 di VS Code
```

---

## 💡 Pro Tips

### 1. Multi-Device Debug
```
1. Connect multiple devices/emulators
2. F5 → Pilih device
3. Run di semua device sekaligus!
```

### 2. Flutter Inspector
```
Cmd+Shift+P → "Flutter: Open DevTools"
- Widget Inspector
- Performance overlay
- Memory profiler
```

### 3. Quick Fix
```
Hover over error → Light bulb 💡 → Quick fix
Keyboard: Cmd+. / Ctrl+.
```

### 4. Format on Save
```
Sudah aktif! Save = auto format + organize imports
```

---

## 📚 Dokumentasi Terkait

- **Quick Start**: Baca `QUICK_START.md`
- **Terminal Workflow**: Baca `DEVELOPMENT.md`
- **Helper Scripts**: Run `./dev_helper.sh`

---

## TL;DR (Too Long; Didn't Read)

### Workflow Paling Simple:

```
1️⃣ Tekan F5 untuk start app

2️⃣ Edit code → Save

   ✅ UI berubah? Selesai!
   ❌ Logic tidak update? Klik 🔁 (Hot Restart)

3️⃣ Kalau masih tidak update:
   ⏹️ Stop → F5 Start lagi

4️⃣ Kalau masih error:
   ⏹️ Stop → ./dev_helper.sh clean → F5
```

**Ingat: Klik 🔁 (Hot Restart) untuk perubahan logic/state!**

---

🎉 **Happy Coding with VS Code!**
