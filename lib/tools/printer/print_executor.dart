import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/printer/format_helper/command_helper.dart';
import 'package:front_office_2/tools/printer/format_helper/esc_pos_generator.dart';
import 'package:front_office_2/tools/printer/sender/ble_print_service.dart';
import 'package:front_office_2/tools/printer/sender/lan_print_service.dart';
import 'package:front_office_2/tools/printer/sender/tcp_print_service.dart';
import 'package:front_office_2/tools/toast.dart';

class PrintExecutor {
  
  static Future<void> testPrint() async {
    try {
      final helper = await _getPrinter();
      final posContent = EscPosGenerator.testPrint(helper);
      await _execute(posContent);
      showToastSuccess('Test print berhasil');
    } catch (e) {
      showToastError('Error test print: $e');
      return;
    }
  }

  static Future<void> printInvoice(String rcp) async {
     try {
      
      final apiResponse = await ApiRequest().getInvoice(rcp);
      
      if(!apiResponse.state){
        showToastError(apiResponse.message);
        return;
      } else if(apiResponse.data == null){
        showToastError('data invoice null ${apiResponse.message}');
        return;
      }

      final helper = await _getPrinter();
      final posContent = EscPosGenerator().printInvoice(apiResponse.data!, helper);
      await _execute(posContent);
      ApiRequest().updatePrintState(rcp, '2');
    } catch (e) {
      showToastError('Gagal cetak invoice: $e');
      return;
    }
  }

  static Future<void> printBill(String roomCode)async{
    try {
      final apiResponse = await ApiRequest().getBill(roomCode);
      if(!apiResponse.state){
        showToastError(apiResponse.message);
        return;
      } else if(apiResponse.data == null){
        showToastError('data tagihan null ${apiResponse.message}');
        return;
      }

      final helper = await _getPrinter();
      final posContent = EscPosGenerator().printBillGenerator(apiResponse.data!, helper);
      await _execute(posContent);
      ApiRequest().updatePrintState(apiResponse.data?.dataInvoice.reception??'', '1');
    }catch (e) {
      showToastError('Gagal cetak bill: $e');
      return;
    }
  }

  static Future<void> printSlip(String rcp)async{
    try {
      final apiResponse = await ApiRequest().checkinSlip(rcp);
      if(!apiResponse.state){
        showToastError(apiResponse.message);
        return;
      } else if(apiResponse.data == null){
        showToastError('data slip null\n${apiResponse.message}');
        return;
      }

      final helper = await _getPrinter();
      final posContent = EscPosGenerator().printSlipCheckin(apiResponse.data!, helper);
      await _execute(posContent);
    }catch (e) {
      showToastError('Gagal cetak slip: $e');
      return;
    }
  }

  static Future<void> printSo(String sol, String roomCode, String guestName, int pax) async {
    try {
      final apiResponse = await ApiRequest().getSol(sol);
      
      if(!apiResponse.state){
        showToastError(apiResponse.message??'Gagal mendapatkan data so');
        return;
      } else if(apiResponse.data == null){
        showToastError('data so null\n${apiResponse.message}');
        return;
      }
      
      final helper = await _getPrinter();
      final posContent = EscPosGenerator().printSo(apiResponse.data!, roomCode, guestName, pax, helper);
      await _execute(posContent);
    }catch (e) {
      showToastError('Gagal cetak so: $e');
      return;
    }
  }

  static Future<void> printDo(OrderedModel order, String roomCode) async {
    try {
      
      final helper = await _getPrinter();
      final posContent = EscPosGenerator().printDo(order, roomCode, helper);
      await _execute(posContent);
    }catch (e) {
      showToastError('Gagal cetak so: $e');
      return;
    }
  }


  static Future<void> printLastSo(String rcp, String roomCode, String guestName, int pax)async{
    try {
      final apiResponse = await ApiRequest().latestSo(rcp);
      
      if(apiResponse.state == null || (!apiResponse.state!)){
        showToastError(apiResponse.message??'Gagal mendapatkan data so terakhir');
        return;
      } else if(apiResponse.data == null){
        showToastError('data so terakhir null\n${apiResponse.message}');
        return;
      }

      final helper = await _getPrinter();
      // final posContent = EscPosGenerator().printSo(apiResponse.data!, helper, roomCode, guestName, pax);
      // await _execute(posContent);
    }catch (e) {
      showToastError('Gagal cetak so terakhir: $e');
      return;
    }
  }

  static Future<CommandHelper> _getPrinter()async{
    try {
      final printer = GlobalProviders.read(printerProvider);
      if (printer.name.isEmpty) {
        throw 'Printer belum dikonfigurasi';
      }

      final profile = await CapabilityProfile.load();
      Generator generator;
     if (printer.printerModel == PrinterModelType.bluetooth80mm ||printer.printerModel == PrinterModelType.tm82x) {
        generator = Generator(PaperSize.mm80, profile);
      } else if (printer.printerModel == PrinterModelType.tmu220u) {
        generator = Generator(PaperSize.mm72, profile, spaceBetweenRows: 0);
      } else {
        generator = Generator(PaperSize.mm58, profile);
      }
      
      final printerConfig = GlobalProviders.read(printerProvider);
      final helper = CommandHelper(
        generator,
        printerModel: printerConfig.printerModel,
      );
      return helper; 
    }catch (e) {
      throw Exception('Error mendapatkan printer: $e');
    }
  }

  static Future<void> _execute(List<int> content) async {
    try {
      final printer = GlobalProviders.read(printerProvider);

      if (printer.connectionType == PrinterConnectionType.printerDriver) {
        await TcpPrinterService.printOnce(
          ip: printer.address,
          port: printer.port!,
          data: content,
        );
      } else if (printer.connectionType == PrinterConnectionType.bluetooth) {
        await BlePrintService.printOnce(
          deviceId: printer.address,
          deviceName: printer.name,
          data: content,
        );
      } else if (printer.connectionType == PrinterConnectionType.lan) {
        await LanPrintService.printOnce(
          ip: printer.address,
          port: printer.port ?? 9100,
          data: content,
        );
      }
    }catch (e) {
      throw 'Gagal terhubung ke printer: $e';
    }
  }
}