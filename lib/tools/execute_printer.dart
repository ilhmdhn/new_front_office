import 'dart:convert';

import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:front_office_2/tools/udp_sender.dart';

class DoPrint{

  static final printerData = PreferencesData.getPrinter();

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

  static printBill(){
    try{
      
    }catch(e){

    }
  }
}