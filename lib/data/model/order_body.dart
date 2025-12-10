import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/tools/preferences.dart';

class GenerateOrderParams{

  static Future<Map<String, dynamic>> orderParams(String roomCode, String rcp, String roomType, int checkinDuration, List<SendOrderModel> orderData)async{
    final chusr = PreferencesData.getUser().userId;
    final deviceId = await PreferencesData.getDeviceModel();
    List<String> invCodeList = List.empty(growable: true);
    List<String> qtyList = List.empty(growable: true);
    List<String> noteList = List.empty(growable: true);
    List<String> priceList = List.empty(growable: true);
    List<String> nameList = List.empty(growable: true);
    List<String> locationList = List.empty(growable: true);

    for (var item in orderData){
      invCodeList.add(item.invCode);
      qtyList.add(item.qty.toString());
      noteList.add(item.note);
      priceList.add(item.price.toString());
      nameList.add(item.name);
      locationList.add(item.location.toString());
    }

    return <String, dynamic>{
      'order_user_name': chusr,
      'order_room_code': roomCode,
      'order_room_type': roomType,
      'order_room_rcp': rcp,
      'order_room_durasi_checkin': checkinDuration.toString(),
      'order_model_android': deviceId,
      'arr_order_inv': invCodeList,
      'arr_order_qty': qtyList,
      'arr_order_notes': noteList,
      'arr_order_price': priceList,
      'arr_order_nama_item': nameList,
      'arr_order_location_item': locationList,
    };
  }
}