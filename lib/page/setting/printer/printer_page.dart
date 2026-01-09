import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/input_formatter.dart';
import 'package:front_office_2/tools/printer/print_executor.dart';
import 'package:front_office_2/tools/printer/sender/ble_print_service.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:permission_handler/permission_handler.dart';

class PrinterPage extends ConsumerStatefulWidget {
  static const nameRoute = '/printer';
  const PrinterPage({super.key});

  @override
  ConsumerState<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends ConsumerState<PrinterPage> {
  List<PrinterList> listPrinter = List.empty(growable: true);
  PrinterList chosedPrinter = PrinterList(name: '', address: '');
  TextEditingController tfIpPc = TextEditingController();
  TextEditingController tfPortPc = TextEditingController();
  TextEditingController tfIpLan = TextEditingController();
  TextEditingController tfPortLan = TextEditingController();
  List<Map<String, String>> printerList = List.empty(growable: true);
  bool isLoading = false;

  PrinterModelType selectedPcPrinterType = PrinterModelType.tmu220u;
  PrinterModelType selectedLanPrinterType = PrinterModelType.tm82x;
  PrinterModelType selectedBluetoothPrinterType = PrinterModelType.bluetooth80mm;

  @override
  void initState() {
    super.initState();
  }

  /// Request Bluetooth permissions untuk BLE scan (Android 12+)
  Future<bool> _requestBluetoothPermissions() async {
    // Request Bluetooth Scan & Connect permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    final scanGranted = statuses[Permission.bluetoothScan]?.isGranted ?? false;
    final connectGranted = statuses[Permission.bluetoothConnect]?.isGranted ?? false;

    if (!scanGranted || !connectGranted) {
      // Check if permanently denied
      if (statuses[Permission.bluetoothScan]?.isPermanentlyDenied ?? false) {
        // Show dialog to open settings
        if (!mounted) return false;
        final shouldOpen = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Bluetooth permission is required to scan for BLE devices.\n\n'
              'Please enable Bluetooth permission in Settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );

        if (shouldOpen == true) {
          await openAppSettings();
        }
      }
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final printer = ref.watch(printerProvider);

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Printer Setting',
          style: CustomTextStyle.titleAppBar(),
        ),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentPrinterCard(printer),
              const SizedBox(height: 20),
              _buildPCPrinterCard(),
              const SizedBox(height: 20),
              // _buildLanPrinterCard(),
              // const SizedBox(height: 20),
              _buildBluetoothPrinterCard(printer),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPrinterCard(PrinterModel printer) {
    final isConnected = printer.name.isNotEmpty;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isConnected
                ? [Colors.green.shade50, Colors.white]
                : [Colors.grey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.print,
                  color: isConnected ? Colors.green : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Current Printer',
                  style: CustomTextStyle.blackMediumSize(20),
                ),
                const Spacer(),
                isConnected
                    ? ElevatedButton.icon(
                        onPressed: () {
                          PrintExecutor.testPrint();
                        },
                        icon: const Icon(Icons.print_outlined, size: 20),
                        label: const Text(
                          'Test',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isConnected ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Not Set',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Printer', printer.name),
            const SizedBox(height: 8),
            _buildInfoRow('Connection', printer.connectionType.displayName),
            const SizedBox(height: 8),
            _buildInfoRow('Address', printer.address),
            const SizedBox(height: 8),
            _buildInfoRow('Port', printer.port?.toString()),
            const SizedBox(height: 8),
            _buildInfoRow('Printer Type', printer.printerModel.displayName),
          ],
        ),
      ),
    );
  }

  Widget _buildPCPrinterCard() {
    return Card(
      elevation: 3,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lan,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text('Network Printer',
                    style: CustomTextStyle.blackMediumSize(18)),
              ],
            ),
            const SizedBox(height: 16),
            _buildIpInputRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanPrinterCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lan,
                  color: Colors.orange.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'LAN Printer',
                  style: CustomTextStyle.blackMediumSize(18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLanInputRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothPrinterCard(PrinterModel printer) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bluetooth,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Bluetooth Printer',
                  style: CustomTextStyle.blackMediumSize(18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PrinterModelType>(
              initialValue: selectedBluetoothPrinterType,
              decoration: InputDecoration(
                labelText: 'Printer Type',
                prefixIcon: const Icon(Icons.print, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
              items: PrinterModelType.values.map((PrinterModelType type) {
                return DropdownMenuItem<PrinterModelType>(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (PrinterModelType? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBluetoothPrinterType = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (isLoading) {
                        showToastWarning('Tunggu proses selesai');
                        return;
                      }

                      // Request Bluetooth permissions (Android 12+)
                      final permissions = await _requestBluetoothPermissions();
                      if (!permissions) {
                        showToastError('Permission Bluetooth ditolak.\nBuka Settings untuk mengaktifkan permission.');
                        return;
                      }

                      // Check Bluetooth enabled
                      final btEnabled = await BlePrintService.isBluetoothEnabled();
                      if (!btEnabled) {
                        showToastWarning('Bluetooth belum aktif. Aktifkan Bluetooth terlebih dahulu');
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final printerListResult = await BlePrintService.scanDevices(
                          scanDuration: const Duration(seconds: 5),
                        );
                        setState(() {
                          isLoading = false;
                          printerList = printerListResult;
                        });

                        if (printerListResult.isEmpty) {
                          showToastWarning('Tidak ada BLE device ditemukan');
                        } else {
                          showToastSuccess('Ditemukan ${printerListResult.length} device');
                        }
                      } on PlatformException catch (e) {
                        setState(() {
                          isLoading = false;
                        });

                        // Handle specific error codes
                        if (e.code == 'PERMISSION_DENIED') {
                          showToastError('Permission Bluetooth ditolak.\nBuka Settings > Apps > Happy Puppy POS > Permissions\ndan aktifkan "Nearby devices"');
                        } else if (e.code == 'BLUETOOTH_OFF') {
                          showToastWarning('Bluetooth tidak aktif atau tidak tersedia');
                        } else if (e.code == 'BLE_NOT_AVAILABLE') {
                          showToastError('BLE tidak tersedia di perangkat ini');
                        } else {
                          showToastError('Gagal scan: ${e.message}');
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        showToastError('Gagal scan device: $e');
                      }
                    },
                    icon: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.search, size: 20),
                    label: Text(
                      isLoading ? 'Scanning...' : 'Scan BLE Devices',
                      style: const TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildBluetoothPrinterList(printer),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    IconData icon;
    switch (title) {
      case 'Printer':
        icon = Icons.print_outlined;
        break;
      case 'Connection':
        icon = Icons.link;
        break;
      case 'Address':
        icon = Icons.location_on_outlined;
        break;
      case 'Printer Type':
        icon = Icons.category_outlined;
        break;
      default:
        icon = Icons.info_outline;
    }

    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(title, style: CustomTextStyle.blackMedium()),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value ?? 'Not set',
            style: TextStyle(
              color: (value == null || value.isEmpty)
                  ? Colors.grey
                  : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIpInputRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<PrinterModelType>(
          initialValue: selectedPcPrinterType,
          decoration: InputDecoration(
            labelText: 'Printer Type',
            prefixIcon: const Icon(Icons.print, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.blue.shade50,
          ),
          items: PrinterModelType.values.map((PrinterModelType type) {
            return DropdownMenuItem<PrinterModelType>(
              value: type,
              child: Text(type.displayName),
            );
          }).toList(),
          onChanged: (PrinterModelType? newValue) {
            if (newValue != null) {
              setState(() {
                selectedPcPrinterType = newValue;
              });
            }
          },
        ),
        const SizedBox(height: 12),
        TextField(
          inputFormatters: [IPAddressInputFormatter()],
          keyboardType: TextInputType.number,
          controller: tfIpPc,
          decoration: InputDecoration(
            hintText: 'Enter IP Address',
            labelText: 'IP Address',
            prefixIcon: const Icon(Icons.router, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          keyboardType: TextInputType.number,
          controller: tfPortPc,
          decoration: InputDecoration(
            hintText: 'Enter Port (e.g., 9100)',
            labelText: 'Port',
            prefixIcon: const Icon(Icons.settings_ethernet, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              if (tfIpPc.text.isEmpty) {
                showToastWarning('Masukkan IP Address terlebih dahulu');
                return;
              }
              int? port;
              if (tfPortPc.text.isNotEmpty) {
                port = int.tryParse(tfPortPc.text);
                if (port == null) {
                  showToastWarning('Port harus berupa angka');
                  return;
                }
              }
              ref.read(printerProvider.notifier).setPrinter(PrinterModel(
                name: 'PC PRINTER',
                port: port,
                printerModel: selectedPcPrinterType,
                connectionType: PrinterConnectionType.printerDriver,
                address: tfIpPc.text,
              ));
              showToastSuccess('PC Printer berhasil disimpan');
            },
            icon: const Icon(Icons.save, size: 20),
            label: const Text('Save PC Printer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanInputRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<PrinterModelType>(
          initialValue: selectedLanPrinterType,
          decoration: InputDecoration(
            labelText: 'Printer Type',
            prefixIcon: const Icon(Icons.print, color: Colors.orange),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
            filled: true,
            fillColor: Colors.orange.shade50,
          ),
          items: PrinterModelType.values.map((PrinterModelType type) {
            return DropdownMenuItem<PrinterModelType>(
              value: type,
              child: Text(type.displayName),
            );
          }).toList(),
          onChanged: (PrinterModelType? newValue) {
            if (newValue != null) {
              setState(() {
                selectedLanPrinterType = newValue;
              });
            }
          },
        ),
        const SizedBox(height: 12),
        TextField(
          inputFormatters: [IPAddressInputFormatter()],
          keyboardType: TextInputType.number,
          controller: tfIpLan,
          decoration: InputDecoration(
            hintText: 'Enter LAN IP Address',
            labelText: 'LAN IP Address',
            prefixIcon: const Icon(Icons.router_outlined, color: Colors.orange),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
            filled: true,
            fillColor: Colors.orange.shade50,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          keyboardType: TextInputType.number,
          controller: tfPortLan,
          decoration: InputDecoration(
            hintText: 'Enter Port (e.g., 9100)',
            labelText: 'Port',
            prefixIcon: const Icon(Icons.settings_ethernet, color: Colors.orange),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
            filled: true,
            fillColor: Colors.orange.shade50,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (tfIpLan.text.isEmpty) {
                    showToastWarning('Masukkan IP Address terlebih dahulu');
                    return;
                  }
                  int? port;
                  if (tfPortLan.text.isNotEmpty) {
                    port = int.tryParse(tfPortLan.text);
                    if (port == null) {
                      showToastWarning('Port harus berupa angka');
                      return;
                    }
                  }
                  ref.read(printerProvider.notifier).setPrinter(PrinterModel(
                    name: 'LAN PRINTER',
                    port: port,
                    printerModel: selectedLanPrinterType,
                    connectionType: PrinterConnectionType.lan,
                    address: tfIpLan.text,
                  ));
                  showToastSuccess('LAN Printer berhasil disimpan');
                },
                icon: const Icon(Icons.save, size: 20),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildBluetoothPrinterList(PrinterModel printer) {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AddOnWidget.loading(),
        ),
      );
    } else if (printerList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.bluetooth_disabled,
                size: 48, color: Colors.blue.shade300),
            const SizedBox(height: 12),
            Text(
              'No Bluetooth Devices Found',
              style: CustomTextStyle.blackMediumSize(16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure Bluetooth is enabled and tap "Scan Devices" to search for printers',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.devices, size: 18, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                '${printerList.length} device(s) found',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          itemCount: printerList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final device = printerList[index];
            final deviceName = device['name'] ?? 'Unknown Device';
            final deviceId = device['id'] ?? '';
            final isCurrentPrinter = printer.address == deviceId;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isCurrentPrinter ? Colors.green.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCurrentPrinter ? Colors.green : Colors.grey.shade300,
                  width: isCurrentPrinter ? 2 : 1,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      isCurrentPrinter ? Colors.green : Colors.blue,
                  child: Icon(
                    isCurrentPrinter ? Icons.check : Icons.bluetooth,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  deviceName,
                  style: TextStyle(
                    fontWeight:
                        isCurrentPrinter ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.fingerprint,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        deviceId,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: isCurrentPrinter
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey.shade400),
                onTap: () {
                  // BLE: Langsung simpan device ID, tidak perlu connect
                  try {
                    ref.read(printerProvider.notifier).setPrinter(PrinterModel(
                      name: deviceName,
                      printerModel: selectedBluetoothPrinterType,
                      connectionType: PrinterConnectionType.bluetooth,
                      address: deviceId,
                    ));
                    showToastSuccess('Printer BLE "$deviceName" berhasil disimpan');
                  } catch (e) {
                    showToastError('Gagal menyimpan printer: $e');
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
