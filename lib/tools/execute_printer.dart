import 'dart:convert';

import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/json_converter.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:front_office_2/tools/udp_sender.dart';

class DoPrint{

  static lastSo(String rcp, String roomCode, String guestName, int pax)async{
    final apiResponse = await ApiRequest().latestSo(rcp);
    if(apiResponse.state != true){
      showToastError(apiResponse.message??'');
      return;
    }else if(isNullOrEmpty(apiResponse.message)){
      showToastError('Kode SO tidak ada');
      return;
    }
    
    printSo(apiResponse.data!, roomCode, guestName, pax);
  }

  static printSo(String sol, String roomCode, String guestName, int pax)async{
    final printerData = PreferencesData.getPrinter();
    
    if(printerData.connection == '3'){
      showToastWarning('send signal into ${printerData.address}');
      try{
        final dataSol = await ApiRequest().getSol(sol);
        
        if(dataSol.state != true){
          showToastError(dataSol.message??'Gagal mendapatkan data so');
          return;
        }else if(isNullOrEmpty(dataSol.data)){
          showToastError('Tidak ada data');
          return;
        }

        List<Map<String, dynamic>> listSol = List.empty(growable: true);

        for (var element in dataSol.data!) {
          listSol.add({
            'name': element.name,
            'note': element.note,
            'qty': element.qty,
          });
        }

        Map<String, dynamic> data = {
          'type': 3,
          'room_code': roomCode,
          'guest': guestName,
          'pax': 3,
          'sol_code': sol,
          'user': PreferencesData.getUser().userId,
          'sol_list': listSol
        };

        final UdpSender udpSender = UdpSender(address: printerData.address, port: 3911);
        
        final sendData = jsonEncode(data);

        await udpSender.sendUdpMessage(sendData);
      }catch(e){
        showToastError('Gagal print SO $e');
      }
    }else{
      showToastWarning('Printer belum di setting');
    }
  }

  static printBill(String roomCode)async{
    try{
      final printerData = PreferencesData.getPrinter();
      if(printerData.connection == '3'){
      showToastWarning('send signal into ${printerData.address}');
      try{
        final billData = await ApiRequest().getBill(roomCode);
        
        if(billData.state != true){
          showToastError(billData.message);
          return;
        }else if(billData.data == null){
          showToastError('Tidak ada data');
          return;
        }

        final bill = billData.data!;

        Map<String, dynamic> data = {
          'type': 1,
          'user': PreferencesData.getUser().userId,
          'bill_data': JsonConverter.generateBillJson(bill),
          'footer_style': 3
        };

        final UdpSender udpSender = UdpSender(address: printerData.address, port: 3911);
        
        final sendData = jsonEncode(data);

        await udpSender.sendUdpMessage(sendData);
      }catch(e){
        showToastError('Gagal print bill $e');
      }
    }else{
      showToastWarning('Printer belum di setting');
    }
    }catch(e){
      showToastError('Error print bill $e');
    }
  }
}