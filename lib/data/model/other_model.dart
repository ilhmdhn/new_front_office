// Enum untuk Printer Model
enum PrinterModelType {
  tmu220u('TMU 220U'),
  tm82x('TM82x'),
  bluetooth80mm('Bluetooth 80MM'),
  bluetooth58mm('Bluetooth 58MM');

  final String displayName;
  const PrinterModelType(this.displayName);

  // Convert dari string ke enum
  static PrinterModelType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'TMU 220U':
      case 'TMU220U': return PrinterModelType.tmu220u;
      case 'TM82X': return PrinterModelType.tm82x;
      case 'BLUETOOTH 80MM':
      case 'BLUETOOTH80MM':
        return PrinterModelType.bluetooth80mm;
      case 'BLUETOOTH 58MM':
      case 'BLUETOOTH58MM':
        return PrinterModelType.bluetooth58mm;
      default:
        return PrinterModelType.bluetooth80mm; // Default
    }
  }
}

// Enum untuk Connection Type
enum PrinterConnectionType {
  bluetooth('Bluetooth'),
  lan('LAN');

  final String displayName;
  const PrinterConnectionType(this.displayName);

  // Convert dari string ke enum
  static PrinterConnectionType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'BLUETOOTH':
        return PrinterConnectionType.bluetooth;
      case 'LAN':
        return PrinterConnectionType.lan;
      case 'PRINTER DRIVER':
      default:
        return PrinterConnectionType.bluetooth; // Default
    }
  }
}

class PrinterModel{
  String name;
  int? port;
  PrinterModelType printerModel;
  PrinterConnectionType connectionType;
  String address;

  PrinterModel({
    required this.name,
    this.port,
    required this.printerModel,
    required this.connectionType,
    required this.address,
  });

  // Helper method untuk convert ke Map (untuk SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'port': port,
      'printerModel': printerModel.displayName,
      'connectionType': connectionType.displayName,
      'address': address,
    };
  }

  // Helper method untuk convert dari Map
  factory PrinterModel.fromJson(Map<String, dynamic> json) {
    return PrinterModel(
      name: json['name'] ?? '',
      port: json['port'],
      printerModel: PrinterModelType.fromString(json['printerModel'] ?? ''),
      connectionType: PrinterConnectionType.fromString(json['connectionType'] ?? ''),
      address: json['address'] ?? '',
    );
  }
}

class PrinterList{
  String name;
  String address;

  PrinterList({
    required this.name,
    required this.address,
  });
}