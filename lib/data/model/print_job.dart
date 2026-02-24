import 'package:front_office_2/data/model/other_model.dart';

class PrintJob {
  final String title;
  final String description;
  final List<int> data;
  final PrinterConnectionType printerType;
  final String target;
  final int port;
  final String printerName;
  final DateTime createdAt;
  int retryCount;

  PrintJob({
    required this.title,
    required this.description,
    required this.data,
    required this.printerType,
    required this.target,
    this.port = 9100,
    this.printerName = '',
    required this.createdAt,
    this.retryCount = 0,
  });
}