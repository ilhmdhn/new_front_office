# 🔌 LAN Printer Port Configuration

## Port yang Digunakan

LAN Printer sekarang menggunakan **Port 9100** (default untuk ESC/POS printer).

---

## 📋 Cara Input IP Address

### **Option 1: IP Saja (Recommended)** ✅
```
192.168.1.222
```
**Otomatis ditambah port 9100** → Jadi: `192.168.1.222:9100`

### **Option 2: IP dengan Port Custom**
```
192.168.1.222:9101
```
**Menggunakan port yang kamu tentukan** → Tetap: `192.168.1.222:9101`

---

## 🌐 Common Port Numbers

| Port | Protokol | Keterangan |
|------|----------|------------|
| **9100** | RAW/ESC/POS | **Default** - Paling umum untuk thermal printer |
| 9101 | RAW/ESC/POS | Alternatif port 1 |
| 9102 | RAW/ESC/POS | Alternatif port 2 |
| 9103 | RAW/ESC/POS | Alternatif port 3 |
| 515 | LPD | Line Printer Daemon (jarang) |
| 631 | IPP | Internet Printing Protocol (tidak didukung) |

---

## 🎯 Cara Cek Port Printer

### **Method 1: Cek Manual Printer**
1. Print network configuration page dari printer
2. Cari "Port" atau "Service Port"
3. Biasanya tertulis: 9100, 9101, dst

### **Method 2: Ping Test**
```bash
# Mac/Linux:
nc -zv 192.168.1.222 9100

# Output jika port open:
# Connection to 192.168.1.222 port 9100 [tcp/*] succeeded!

# Windows PowerShell:
Test-NetConnection -ComputerName 192.168.1.222 -Port 9100

# Output:
# TcpTestSucceeded : True
```

### **Method 3: Scan Multiple Ports**
```bash
# Mac/Linux - Scan port 9100-9103:
for port in 9100 9101 9102 9103; do
  nc -zv 192.168.1.222 $port 2>&1
done

# Windows PowerShell:
9100..9103 | ForEach-Object {
  Test-NetConnection -ComputerName 192.168.1.222 -Port $_ -InformationLevel Quiet
}
```

---

## 🔧 Troubleshooting Port Issues

### **Issue: Connection Timeout**

**Coba port lain:**
1. Default: `192.168.1.222:9100`
2. Alt 1: `192.168.1.222:9101`
3. Alt 2: `192.168.1.222:9102`
4. LPD: `192.168.1.222:515`

### **Issue: "Port is closed"**

**Solusi:**
1. ✅ Cek printer settings
2. ✅ Pastikan RAW protocol enabled
3. ✅ Restart printer
4. ✅ Cek firewall di printer

---

## 💡 Examples

### **Epson TM-T88V**
```
IP: 192.168.1.100
Port: 9100
Format input: 192.168.1.100
```

### **Star TSP143**
```
IP: 192.168.1.101
Port: 9100
Format input: 192.168.1.101
```

### **Xprinter XP-365B**
```
IP: 192.168.1.102
Port: 9100
Format input: 192.168.1.102
```

### **Custom Port Example**
```
IP: 192.168.1.103
Port: 9101 (custom)
Format input: 192.168.1.103:9101
```

---

## 🎨 Visual Guide

### **Workflow:**
```
User Input          →  System Processing        →  Final Address
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

192.168.1.222       →  + default port (9100)   →  192.168.1.222:9100

192.168.1.222:9101  →  sudah ada port          →  192.168.1.222:9101
```

---

## 📝 Logging

Saat test print, check console untuk confirm port:

```
Full printer address: 192.168.1.222:9100
Connecting to LAN printer: 192.168.1.222:9100
Connected successfully
```

---

## 🚀 Quick Reference

### **Default Setup (90% kasus)**
```
1. Input IP: 192.168.1.xxx
2. Port otomatis: 9100
3. Format final: 192.168.1.xxx:9100
```

### **Custom Port Setup**
```
1. Input IP:Port: 192.168.1.xxx:9101
2. Port digunakan: 9101
3. Format final: 192.168.1.xxx:9101
```

---

## ⚠️ Common Mistakes

### ❌ **SALAH:**
```
192.168.1.222 9100        ← Space, bukan colon
192.168.1.222-9100        ← Dash, bukan colon
192.168.1.222.9100        ← Dot, bukan colon
```

### ✅ **BENAR:**
```
192.168.1.222             ← IP saja (port otomatis 9100)
192.168.1.222:9100        ← IP:Port dengan colon
```

---

## 🔍 Advanced: Telnet Test

Test manual dengan telnet untuk verify port:

```bash
# Connect
telnet 192.168.1.222 9100

# Jika berhasil:
# Trying 192.168.1.222...
# Connected to 192.168.1.222.
# Escape character is '^]'.

# Type sesuatu dan Enter - akan print di printer!
TEST PRINT

# Keluar: Ctrl+] lalu ketik 'quit'
```

---

## 📊 Port Testing Matrix

| IP | Port | Test Command | Expected Result |
|----|------|--------------|-----------------|
| 192.168.1.222 | 9100 | `nc -zv 192.168.1.222 9100` | Connection succeeded |
| 192.168.1.222 | 9101 | `nc -zv 192.168.1.222 9101` | Check if open |
| 192.168.1.222 | 9102 | `nc -zv 192.168.1.222 9102` | Check if open |
| 192.168.1.222 | 515 | `nc -zv 192.168.1.222 515` | LPD port |

---

## 🎯 Key Takeaways

1. **Port 9100** adalah default dan paling umum
2. Input **IP saja** untuk auto port 9100
3. Input **IP:PORT** untuk custom port
4. Gunakan **telnet** atau **nc** untuk test port
5. Cek **printer manual** untuk port yang benar

---

Happy Printing! 🖨️
