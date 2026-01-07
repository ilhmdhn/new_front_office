# Printer Enum Usage Guide

## 📋 Available Enums

### 1. **PrinterModelType**
```dart
enum PrinterModelType {
  tmu220u,        // TMU 220U
  tm82x,          // TM82x
  bluetooth80mm,  // Bluetooth 80MM
}
```

### 2. **PrinterConnectionType**
```dart
enum PrinterConnectionType {
  bluetooth,      // Bluetooth
  lan,            // LAN
  printerDriver,  // Printer Driver
}
```

---

## 🎯 Cara Penggunaan

### **1. Membuat Printer Model**

```dart
// Cara 1: Langsung dengan enum
final printer = PrinterModel(
  name: 'Printer Kasir',
  port: 9100,
  printerModel: PrinterModelType.tm82x,
  connectionType: PrinterConnectionType.lan,
  address: '192.168.1.100',
);
```

### **2. Convert dari String ke Enum**

```dart
// Dari user input string
String userSelectedModel = 'TMU 220U';
String userSelectedConnection = 'Bluetooth';

final printer = PrinterModel(
  name: 'Printer Kasir',
  printerModel: PrinterModelType.fromString(userSelectedModel),
  connectionType: PrinterConnectionType.fromString(userSelectedConnection),
  address: '00:11:22:33:44:55',
);
```

### **3. Mendapatkan Display Name**

```dart
final printer = PrinterModel(
  name: 'Printer Kasir',
  printerModel: PrinterModelType.bluetooth80mm,
  connectionType: PrinterConnectionType.bluetooth,
  address: '00:11:22:33:44:55',
);

// Tampilkan ke UI
print(printer.printerModel.displayName);    // Output: "Bluetooth 80MM"
print(printer.connectionType.displayName);  // Output: "Bluetooth"
```

### **4. Simpan ke SharedPreferences (JSON)**

```dart
// Convert ke JSON
final printer = PrinterModel(
  name: 'Printer Kasir',
  printerModel: PrinterModelType.tmu220u,
  connectionType: PrinterConnectionType.bluetooth,
  address: '00:11:22:33:44:55',
);

Map<String, dynamic> json = printer.toJson();
// Output:
// {
//   'name': 'Printer Kasir',
//   'port': null,
//   'printerModel': 'TMU 220U',
//   'connectionType': 'Bluetooth',
//   'address': '00:11:22:33:44:55'
// }

// Simpan ke SharedPreferences
String jsonString = jsonEncode(json);
SharedPreferences.setString('printer', jsonString);
```

### **5. Load dari SharedPreferences**

```dart
// Load dari SharedPreferences
String? jsonString = SharedPreferences.getString('printer');
if (jsonString != null) {
  Map<String, dynamic> json = jsonDecode(jsonString);
  PrinterModel printer = PrinterModel.fromJson(json);

  print(printer.printerModel.displayName);    // "TMU 220U"
  print(printer.connectionType.displayName);  // "Bluetooth"
}
```

---

## 🎨 Contoh di Widget (Dropdown)

### **Dropdown Printer Model**

```dart
class PrinterSettingPage extends StatefulWidget {
  @override
  State<PrinterSettingPage> createState() => _PrinterSettingPageState();
}

class _PrinterSettingPageState extends State<PrinterSettingPage> {
  PrinterModelType selectedModel = PrinterModelType.bluetooth80mm;
  PrinterConnectionType selectedConnection = PrinterConnectionType.bluetooth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown Printer Model
        DropdownButton<PrinterModelType>(
          value: selectedModel,
          items: PrinterModelType.values.map((model) {
            return DropdownMenuItem(
              value: model,
              child: Text(model.displayName),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedModel = value!;
            });
          },
        ),

        // Dropdown Connection Type
        DropdownButton<PrinterConnectionType>(
          value: selectedConnection,
          items: PrinterConnectionType.values.map((connection) {
            return DropdownMenuItem(
              value: connection,
              child: Text(connection.displayName),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedConnection = value!;
            });
          },
        ),

        // Save Button
        ElevatedButton(
          onPressed: () {
            final printer = PrinterModel(
              name: 'Main Printer',
              printerModel: selectedModel,
              connectionType: selectedConnection,
              address: '00:11:22:33:44:55',
            );

            // Save to SharedPreferences or Riverpod
            // ...
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
```

---

## 🔄 Migration dari String ke Enum

### **Sebelum (String):**
```dart
final printer = PrinterModel(
  name: 'Printer Kasir',
  printerModel: 'TMU 220U',        // ❌ String biasa
  connectionType: 'Bluetooth',     // ❌ String biasa
  address: '00:11:22:33:44:55',
);
```

### **Sesudah (Enum):**
```dart
final printer = PrinterModel(
  name: 'Printer Kasir',
  printerModel: PrinterModelType.tmu220u,                // ✅ Type-safe
  connectionType: PrinterConnectionType.bluetooth,       // ✅ Type-safe
  address: '00:11:22:33:44:55',
);
```

---

## ✅ Keuntungan Menggunakan Enum

1. **✅ Type Safety** - Tidak bisa salah ketik "Bluetoth" atau "TMU220U"
2. **✅ Autocomplete** - IDE akan suggest semua pilihan yang valid
3. **✅ Compile-time Check** - Error akan terdeteksi saat compile, bukan runtime
4. **✅ Refactoring** - Mudah rename atau update value
5. **✅ Dokumentasi** - Clear apa saja pilihan yang tersedia

---

## 🎯 Best Practices

### ✅ **BAIK:**
```dart
// Gunakan enum untuk validasi
if (printer.connectionType == PrinterConnectionType.lan) {
  // Setup LAN connection
} else if (printer.connectionType == PrinterConnectionType.bluetooth) {
  // Setup Bluetooth connection
}
```

### ❌ **JANGAN:**
```dart
// Jangan compare dengan string
if (printer.connectionType.displayName == 'LAN') {  // ❌ BURUK
  // ...
}
```

### ✅ **BAIK:**
```dart
// Switch statement dengan enum
switch (printer.printerModel) {
  case PrinterModelType.tmu220u:
    // TMU 220U specific config
    break;
  case PrinterModelType.tm82x:
    // TM82x specific config
    break;
  case PrinterModelType.bluetooth80mm:
    // Bluetooth 80MM specific config
    break;
}
```

---

## 📞 Support

Jika ada pertanyaan, hubungi team developer.
