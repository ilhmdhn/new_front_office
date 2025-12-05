# 🖨️ LAN Printer Troubleshooting Guide

## Masalah: "Connected successfully" tapi tidak print

Jika log menunjukkan:
```
✓ Connected successfully
✓ Print completed successfully
✓ Disconnected successfully
```

Tapi printer fisik TIDAK print, ikuti langkah ini:

---

## 🔧 Perbaikan yang Sudah Dilakukan

### ✅ 1. Tambah Initialize Command
```dart
// ESC @ - Initialize printer
bytes += [0x1B, 0x40];
```
Reset printer state sebelum print.

### ✅ 2. Tambah CUT Command (PALING PENTING!)
```dart
bytes += helper.cut(); // GS V command
```
**Kenapa penting?** Banyak printer ESC/POS butuh CUT command untuk flush buffer dan execute print.

### ✅ 3. Tambah Delay Sebelum Disconnect
```dart
await Future.delayed(const Duration(milliseconds: 500));
```
Kasih waktu printer untuk process data sebelum koneksi ditutup.

### ✅ 4. Tambah Lebih Banyak Content
Printer lebih reliable dengan content yang lebih banyak.

---

## 🔍 Checklist Troubleshooting

### 1. ✅ **Cek IP Address Printer**

```bash
# Test ping dari terminal/cmd
ping 192.168.1.222

# Harus reply:
# Reply from 192.168.1.222: bytes=32 time<1ms TTL=64
```

**Jika gagal ping:**
- ❌ IP address salah
- ❌ Printer tidak di network yang sama
- ❌ Firewall block

---

### 2. ✅ **Cek Port Printer (Biasanya 9100)**

```bash
# Di terminal Mac/Linux:
nc -zv 192.168.1.222 9100

# Harus output:
# Connection to 192.168.1.222 port 9100 [tcp/*] succeeded!

# Di Windows PowerShell:
Test-NetConnection -ComputerName 192.168.1.222 -Port 9100
```

**Jika port tertutup:**
- Cek printer settings
- Printer mungkin pakai port lain (bisa 9101, 9102, dll)

---

### 3. ✅ **Cek Tipe Printer**

**ESC/POS Printer:** ✅ Support
- Epson TM series
- Star TSP series
- Xprinter
- Most thermal receipt printers

**Laser/Inkjet Printer:** ❌ Mungkin tidak support
- HP LaserJet
- Canon Pixma
- Biasanya butuh driver spesifik

---

### 4. ✅ **Test dengan Raw Print (Alternative Method)**

Jika masih tidak print, coba test dengan raw command:

```dart
// Tambah di lanprint_executor.dart untuk testing:
Future<void> testRawPrint() async {
  final setupPrinter = Printer(
    address: '192.168.1.222',
    name: 'LAN Printer',
    connectionType: ConnectionType.NETWORK,
    isConnected: false,
  );

  try {
    await _printerManager.connect(setupPrinter);

    // Raw ESC/POS commands
    List<int> rawBytes = [];

    // Initialize
    rawBytes += [0x1B, 0x40];

    // Print "TEST" in ASCII
    rawBytes += [0x54, 0x45, 0x53, 0x54]; // "TEST"

    // New line
    rawBytes += [0x0A];

    // Feed
    rawBytes += [0x1B, 0x64, 0x03]; // Feed 3 lines

    // Cut
    rawBytes += [0x1D, 0x56, 0x00]; // Full cut

    await _printerManager.printData(setupPrinter, rawBytes);

    await Future.delayed(const Duration(milliseconds: 500));
  } finally {
    await _printerManager.disconnect(setupPrinter);
  }
}
```

---

### 5. ✅ **Cek Settings Printer**

Di printer network settings, pastikan:

- ✅ Protocol: **RAW** atau **ESC/POS**
- ✅ Port: **9100** (default)
- ✅ Encoding: **UTF-8** atau **ASCII**
- ❌ Bukan: **IPP**, **LPD**, **HTTP**

---

### 6. ✅ **Test dengan Aplikasi Lain**

Install app test printer di Android:
- **RawBT ESC/POS Printer** (Play Store)
- **Bluetooth & LAN Printer** (Play Store)

Jika app lain bisa print → Problem di code
Jika app lain juga gagal → Problem di printer/network

---

## 🐛 Debug Mode

Aktifkan debug lengkap untuk troubleshooting:

```dart
// Di lanprint_executor.dart, tambah log:
debugPrint('IP Address: ${printerConfig.address}');
debugPrint('Printer Name: ${printerConfig.name}');
debugPrint('Connection Type: ${setupPrinter.connectionType}');
debugPrint('Total Bytes: ${bytes.length}');
debugPrint('First 100 bytes: ${bytes.take(100).toList()}');
```

Check console untuk:
- Bytes length harus > 0
- Data bytes harus valid

---

## 📋 Common Issues & Solutions

### Issue 1: "Connected successfully" tapi tidak print
**Solution:**
- ✅ Tambah CUT command (sudah fixed)
- ✅ Tambah delay sebelum disconnect (sudah fixed)
- ✅ Pastikan port 9100 terbuka

### Issue 2: "Connection timeout"
**Solution:**
- Cek IP address
- Cek network connectivity
- Cek firewall

### Issue 3: "Garbage characters" terprint
**Solution:**
- Printer bukan ESC/POS compatible
- Encoding salah
- Capability profile salah

### Issue 4: Print hanya sebagian
**Solution:**
- Tambah delay lebih lama (1000ms)
- Kirim data dalam chunks kecil

---

## 🔬 Advanced Testing

### Test 1: Manual Telnet Test

```bash
# Connect via telnet
telnet 192.168.1.222 9100

# Type (akan print di printer):
TEST
^]  # Ctrl+] untuk keluar
quit
```

Jika telnet test berhasil → Printer OK, issue di code
Jika telnet test gagal → Printer issue

### Test 2: Python Test Script

```python
import socket

# Create socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect
sock.connect(('192.168.1.222', 9100))

# Send data
data = b'\x1B\x40'  # Initialize
data += b'TEST PRINT\n'
data += b'\x1B\x64\x03'  # Feed 3 lines
data += b'\x1D\x56\x00'  # Cut

sock.send(data)
sock.close()
```

---

## 🎯 Recommended Settings

### Network Settings
```
IP: 192.168.1.xxx (static recommended)
Subnet: 255.255.255.0
Gateway: 192.168.1.1
Port: 9100 (default ESC/POS)
Protocol: RAW/Socket
```

### App Settings
```dart
connectionType: ConnectionType.NETWORK
paperSize: PaperSize.mm80
profile: await CapabilityProfile.load()
```

---

## ⚡ Quick Fix Checklist

Jika printer masih tidak print, coba ini:

1. ☐ Restart printer (power off/on)
2. ☐ Restart WiFi router
3. ☐ Pastikan app dan printer di network sama
4. ☐ Test dengan IP `ping`
5. ☐ Test dengan `telnet` port 9100
6. ☐ Cek log untuk error messages
7. ☐ Coba raw print test
8. ☐ Update firmware printer (jika ada)

---

## 📞 Jika Masih Gagal

1. **Check model printer**
   - Cari manual printer
   - Cek apakah support ESC/POS
   - Cari command set yang didukung

2. **Coba port lain**
   - 9100 (default)
   - 9101, 9102, 9103
   - 515 (LPD)

3. **Contact support printer**
   - Minta dokumentasi ESC/POS
   - Tanyakan raw printing settings

---

## 🔑 Key Points to Remember

1. **CUT command is critical** - Without it, many printers won't print
2. **Delay before disconnect** - Give printer time to process
3. **Port 9100** - Standard for ESC/POS over network
4. **Same network** - App and printer must be on same subnet
5. **ESC/POS only** - This won't work with laser/inkjet printers

---

## 📊 Debug Log Example

**Good log (should print):**
```
START PRINT TEST LAN PRINTER
Connecting to LAN printer: 192.168.1.222
Connected successfully
Printing 450 bytes...
Data: [27, 64, 27, 97, 1, 72, 65, 80, 80, 89, ...]
Print completed successfully
Disconnecting from LAN printer...
Disconnected successfully
END PRINT TEST LAN PRINTER
```

**Bad log (won't print):**
```
Printing 0 bytes...  ← MASALAH! No data
```

---

Happy Printing! 🎉
