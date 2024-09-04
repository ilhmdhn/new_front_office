import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class RoomCheckinState{
  bool state;
  String? message;
  List<RoomCheckinStateModel>? data;

  RoomCheckinState({
    required this.state,
    this.message,
    this.data
  });

  factory RoomCheckinState.fromJson(Map<String, dynamic>json){
    return RoomCheckinState(
      state: json['state'],
      message: json['message'],
      data: List<RoomCheckinStateModel>.from(
        (json['data'] as List).map((e) => RoomCheckinStateModel.fromJson(e)))
      );
  }
}

class RoomCheckinStateModel{
  String room;
  String state;
  String guest;
  String timeRemain;
  int so;
  int delivery;
  int cancel;
  int process;

  RoomCheckinStateModel({
    required this.room,
    this.state = '0',
    this.guest = '',
    this.timeRemain = '',
    this.so = 0,
    this.delivery = 0,
    this.cancel = 0,
    this.process = 0,
  });

  factory RoomCheckinStateModel.fromJson(Map<String, dynamic> json){
    final soList = json['order_inventory_progress'];
    num soCount = 0;
    for(var so in soList){
      if(so['order_status'] == 1){
        soCount += so['qty'];
      }
    }

    final progressList = json['order_inventory_progress'];
    num progressCount = 0;

    for(var progress in progressList){
      if(progress['order_status'] == 3){
        progressCount += progress['order_qty_belum_terkirim'];
      }
    }

    final orderFinishList = json['summary_order_inventory'];
    num finishCount = 0;
    for(var finish in orderFinishList){
      finishCount +=  finish['qty'];
    }

    final cancelOrderList = json['order_inventory_cancelation'];
    num cancelCount = 0;
    for(var cancel in cancelOrderList){
      cancelCount += cancel['qty'];
    }

    return RoomCheckinStateModel(
      room: json['kamar'],
      state: json['status_print'],
      guest: json['nama_member'],
      timeRemain:  '${json['sisa_jam_checkin']<1? '0': json['sisa_jam_checkin'].toString()}:${json['sisa_menit_checkin'] < 1 ? '0' : json['sisa_menit_checkin'].toString()}' ,
      so: soCount.toInt(),
      process: progressCount.toInt(),
      delivery: finishCount.toInt(),
      cancel: cancelCount.toInt()
    );
  }
}