import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/btprint_executor.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/input_formatter.dart';
import 'package:front_office_2/tools/lanprint_executor.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/printer_tools.dart';
import 'package:front_office_2/tools/toast.dart';

class PrinterPage extends StatefulWidget {
  static const nameRoute = '/printer';
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  List<PrinterList> listPrinter = List.empty(growable: true);
  PrinterList chosedPrinter = PrinterList(name: '', address: '');
  TextEditingController tfIpPc = TextEditingController();
  TextEditingController tfIpLan = TextEditingController();
  List<BluetoothDevice> printerList = List.empty(growable: true);
  PrinterModel printer = PreferencesData.getPrinter();
  bool isLoading = false;
  String selectedLanPrinterType = 'Epson TMU82x';
  String selectedBluetoothPrinterType = 'Bluetooth printer 80 mm';

  final List<String> lanPrinterTypes = ['Epson TMU82x', 'Bixolon', 'TMU220'];
  final List<String> bluetoothPrinterTypes = ['Bluetooth printer 80 mm', 'Bluetooth Printer 57mm'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              _buildCurrentPrinterCard(),
              const SizedBox(height: 20),
              _buildPCPrinterCard(),
              const SizedBox(height: 20),
              _buildLanPrinterCard(),
              const SizedBox(height: 20),
              _buildBluetoothPrinterCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPrinterCard() {
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
                          if (printer.connection == '2') {
                            BtprintExecutor().testPrint();
                          } else if (printer.connection == '3') {
                            showToastWarning(
                                'Fitur test print hanya tersedia untuk Bluetooth Printer');
                          } else if (printer.connection == '4') {
                            LanprintExecutor().testPrint();
                          }
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
            _buildInfoRow('Connection', printer.connection),
            const SizedBox(height: 8),
            _buildInfoRow('Address', printer.address),
            const SizedBox(height: 8),
            _buildInfoRow('Printer Type', printer.type),
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
                  Icons.computer,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text('Android Printer Driver',
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

  Widget _buildBluetoothPrinterCard() {
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
            DropdownButtonFormField<String>(
              value: selectedBluetoothPrinterType,
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
              items: bluetoothPrinterTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
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
                      setState(() {
                        isLoading = true;
                      });
                      final printerListResult =
                          await PrinterTools().getBluetoothDevices();
                      setState(() {
                        isLoading = false;
                        printerList = printerListResult;
                      });
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
                      isLoading ? 'Scanning...' : 'Scan Devices',
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
            _buildBluetoothPrinterList(),
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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              if (tfIpPc.text.isEmpty) {
                showToastWarning('Masukkan IP Address terlebih dahulu');
                return;
              }
              PreferencesData.setPrinter(PrinterModel(
                name: 'PC PRINTER',
                connection: '3',
                type: 'TMU220',
                address: tfIpPc.text,
              ));
              setState(() {
                printer = PreferencesData.getPrinter();
              });
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
        DropdownButtonFormField<String>(
          value: selectedLanPrinterType,
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
          items: lanPrinterTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (String? newValue) {
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
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (tfIpLan.text.isEmpty) {
                    showToastWarning('Masukkan IP Address terlebih dahulu');
                    return;
                  }
                  PreferencesData.setPrinter(PrinterModel(
                    name: 'LAN PRINTER',
                    connection: '4',
                    type: selectedLanPrinterType,
                    address: tfIpLan.text,
                  ));
                  setState(() {
                    printer = PreferencesData.getPrinter();
                  });
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

  Widget _buildBluetoothPrinterList() {
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
            final isCurrentPrinter = printer.address == device.address;

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
                  device.name ?? 'Unknown Device',
                  style: TextStyle(
                    fontWeight:
                        isCurrentPrinter ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(device.address ?? 'No Address'),
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
                onTap: () async {
                  if (isLoading) {
                    showToastWarning('Tunggu proses selesai');
                    return;
                  }
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    PreferencesData.setPrinter(PrinterModel(
                      name: device.name ?? 'Unknown',
                      connection: '2',
                      type: selectedBluetoothPrinterType,
                      address: device.address ?? '',
                    ));
                    setState(() {
                      printer = PreferencesData.getPrinter();
                    });
                    await BtPrint().connectToDevice(device);
                    showToastSuccess(
                        'Printer ${device.name} berhasil terhubung');
                  } catch (e) {
                    showToastError('Gagal terhubung ke printer');
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
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
