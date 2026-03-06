import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/list.dart';

class PaymentListDialog{

  static Future<String?> eMoneyList(BuildContext ctx, String? choosed) async {
  // Simpan nilai pilihan di variabel lokal di dalam fungsi agar bisa diakses oleh Navigator.pop
  String? tempSelected = choosed;

  return showDialog(
    barrierDismissible: false,
    context: ctx,
    builder: (BuildContext ctxDialog) {
      return StatefulBuilder(
        builder: (ctxStfl, setState) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Center(
              child: Text(
                'Pilih E-Money',
                style: CustomTextStyle.titleAlertDialog(),
              ),
            ),
            content: SizedBox(
              width: double.maxFinite, // Penting agar GridView tahu lebar maksimal
              child: GridView.builder(
                shrinkWrap: true, // Penting: Menyesuaikan tinggi GridView dengan jumlah item
                physics: const NeverScrollableScrollPhysics(), // Scroll diatur oleh dialog
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,       // 2 Kolom
                  childAspectRatio: 2.5,   // Rasio lebar:tinggi. Semakin besar, tombol semakin tipis (minimalis)
                  crossAxisSpacing: 10,    // Jarak horizontal
                  mainAxisSpacing: 10,     // Jarak vertikal
                ),
                itemCount: eMoneyValueList.length,
                itemBuilder: (context, index) {
                  final item = eMoneyValueList[index];
                  final bool isSelected = tempSelected == item;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        tempSelected = item;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? CustomColorStyle.appBarBackground() : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: CustomColorStyle.appBarBackground(),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(ctxDialog),
                style: CustomButtonStyle.cancel(),
                child: Text('CANCEL', style: CustomTextStyle.whiteStandard()),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctxDialog, tempSelected),
                style: CustomButtonStyle.confirm(),
                child: Text('CONFIRM', style: CustomTextStyle.whiteStandard()),
              ),
            ],
          );
        },
      );
    },
  );
}

  static Future<String?> piutangList(BuildContext ctx, String? choosed) async {
  // Gunakan variabel lokal untuk menampung perubahan state di dalam StatefulBuilder
  String? tempSelected = choosed;

  return showDialog(
    barrierDismissible: false,
    context: ctx,
    builder: (BuildContext ctxDialog) {
      return StatefulBuilder(
        builder: (ctxStfl, setState) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            // Berikan padding sedikit agar grid tidak menempel ke pinggir dialog
            contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            titlePadding: const EdgeInsets.only(top: 16, bottom: 0),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Center(
              child: Text(
                'Piutang',
                style: CustomTextStyle.titleAlertDialog(),
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(ctx).size.width * 0.8, // Batasi lebar dialog
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: piutangValueList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.8, // Tombol tipis minimalis
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = piutangValueList[index];
                    bool isSelected = tempSelected == item;
                
                    return InkWell(
                      onTap: () {
                        setState(() {
                          tempSelected = item;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? CustomColorStyle.appBarBackground() : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: CustomColorStyle.appBarBackground(),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctxDialog);
                },
                style: CustomButtonStyle.cancel(),
                child: Text('CANCEL', style: CustomTextStyle.whiteStandard()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctxDialog, tempSelected);
                },
                style: CustomButtonStyle.confirm(),
                child: Text('CONFIRM', style: CustomTextStyle.whiteStandard()),
              ),
            ],
          );
        },
      );
    },
  );
}

  static Future<EdcDataModel?> selectEdc(BuildContext ctx)async{
    return showDialog(
      context: ctx, 
      builder: (BuildContext ctxDialog){
        return AlertDialog(
          title: Text('Pilih Edc', style: CustomTextStyle.titleAlertDialog(),),
        );
      });
  }
}