# 🚀 Quick Start Guide

## 🎯 Pilih Workflow Kamu:

### 🅰️ **Pakai VS Code Button (F5)** ← RECOMMENDED! LEBIH MUDAH!
👉 **Baca:** [VSCODE_WORKFLOW.md](VSCODE_WORKFLOW.md)

**TL;DR:**
1. Tekan **F5** untuk start app
2. Edit code → **Save** → Otomatis reload!
3. Kalau logic/state tidak update → Klik **🔁** (Hot Restart) di toolbar

---

### 🅱️ **Pakai Terminal (`flutter run`)**

## Masalah: Hot Reload Tidak Bekerja?

Jika perubahan code tidak muncul di app, ikuti langkah ini:

### ⚡ Solusi Cepat (90% kasus)

Saat app sedang running di console, **tekan `R` (huruf besar)** untuk Hot Restart, bukan `r`.

```
r  = Hot Reload (hanya UI) ❌ Tidak cukup untuk state/logic
R  = Hot Restart (reset state) ✅ INI yang harus digunakan!
```

---

## 📋 Workflow Development

### 1. Pertama kali setelah git pull:
```bash
./dev_helper.sh rebuild
flutter run
```

### 2. Saat development (app sudah running):

**Ubah UI (widget, text, warna):**
- Save file → Tekan `r` di console

**Ubah logic, state, preferences:**
- Save file → Tekan `R` di console (RESTART, bukan reload!)

**Ubah printer, bluetooth, native code:**
- Stop app (tekan `q`)
- Run ulang: `flutter run`

### 3. Jika `R` tidak bekerja:
```bash
# Stop app (tekan 'q')
./dev_helper.sh clean
flutter run
```

---

## 🛠️ Helper Commands

```bash
# Make executable (sekali saja)
chmod +x dev_helper.sh

# Clean build cache
./dev_helper.sh clean

# Full rebuild
./dev_helper.sh rebuild

# Run app
./dev_helper.sh run

# Clean Gradle cache (jika ada error Android)
./dev_helper.sh gradle-clean

# Nuclear option (jika semua gagal)
./dev_helper.sh full-reset
```

---

## ❓ FAQ

**Q: Kenapa hot reload tidak bekerja?**
A: Hot reload (`r`) hanya untuk UI. Untuk state/logic, gunakan hot restart (`R`).

**Q: Sudah pakai `R` tapi tetap tidak update?**
A: Stop app dan run ulang, atau gunakan `./dev_helper.sh clean`.

**Q: Printer settings tidak update?**
A: Printer settings di SharedPreferences. Harus restart app sepenuhnya (stop + run ulang).

**Q: Kapan harus `flutter clean`?**
A: Jika hot restart (`R`) tidak bekerja, atau setelah update dependencies.

---

## 📚 Dokumentasi Lengkap

Baca [DEVELOPMENT.md](DEVELOPMENT.md) untuk troubleshooting lengkap dan best practices.

---

## 💡 Tips Pro

1. **Gunakan VS Code Debug Panel** (F5) untuk auto hot reload
2. **Lihat console messages** untuk error yang muncul
3. **Restart IDE** jika VS Code mulai lambat
4. **Update Flutter** regular: `flutter upgrade`

---

**TL;DR: Gunakan `R` (Hot Restart), bukan `r` (Hot Reload)!**
