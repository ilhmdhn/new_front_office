import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/app_settings_provider.dart';
import 'package:front_office_2/riverpod/printer/setting_printer.dart';

class PrinterStylePage extends ConsumerWidget {
  static const nameRoute = '/printer-style';
  const PrinterStylePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        'Printer Style',
        style: CustomTextStyle.titleAppBar(),
      ),
      backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      backgroundColor: CustomColorStyle.background(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9)
                  ),
                  child: CheckboxListTile(
                    activeColor: const Color(0xFF1976D2),
                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    title: Text('Retur' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    subtitle: Text('Tampilkan retur pada hasil cetak?', style: const TextStyle(fontSize: 12), maxLines: 2,),
                    value: ref.watch(showReturProvider),
                    onChanged: (bool? value) async{
                      ref.read(showReturProvider.notifier).setShowRetur(value??false);
                    },
                  ),
                ),              
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9)
                  ),
                  child: CheckboxListTile(
                    activeColor: const Color(0xFF1976D2),
                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    title: Text('Total promo' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    subtitle: Text('Tampilkan totap promo item pada cetakan?', style: const TextStyle(fontSize: 12), maxLines: 2,),
                    value: ref.watch(showTotalItemPromoProvider),
                    onChanged: (bool? value) async{
                      ref.read(showTotalItemPromoProvider.notifier).setShowTotalItemPromo(value??false);
                    },
                  ),
                ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: CheckboxListTile(
                  activeColor: const Color(0xFF1976D2),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text('Promo disetiap item' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text('Tampilkan promo dibawah nama item?', style: const TextStyle(fontSize: 12), maxLines: 2,),
                  value: ref.watch(showPromoBelowItemProvider),
                  onChanged: (bool? value) async{
                    ref.read(showPromoBelowItemProvider.notifier).setShowPromoBelowItem(value??false);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: CheckboxListTile(
                  activeColor: const Color(0xFF1976D2),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text('Cetak Slip Checklin' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text('Slip Checkin', style: const TextStyle(fontSize: 12), maxLines: 2,),
                  value: ref.watch(printSlipCheckinProvider),
                  onChanged: (bool? value) async{
                    ref.read(printSlipCheckinProvider.notifier).setPrintSlipCheckin(value??false);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: CheckboxListTile(
                  activeColor: const Color(0xFF1976D2),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text('Cetak Slip Order' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text('Slip Checkin', style: const TextStyle(fontSize: 12), maxLines: 2,),
                  value: ref.watch(printSlipOrderProvider),
                  onChanged: (bool? value) async{
                    ref.read(printSlipOrderProvider.notifier).setPrintSlipOrder(value??false);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: CheckboxListTile(
                  activeColor: const Color(0xFF1976D2),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text('Cetak Delivery Order' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text('Slip Checkin', style: const TextStyle(fontSize: 12), maxLines: 2,),
                  value: ref.watch(printSlipDeliveryOrderProvider),
                  onChanged: (bool? value) async{
                    ref.read(printSlipDeliveryOrderProvider.notifier).setPrintSlipDeliveryOrder(value??false);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: CheckboxListTile(
                  activeColor: const Color(0xFF1976D2),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text('Cetak Bill' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text('Cetak Bill', style: const TextStyle(fontSize: 12), maxLines: 2,),
                  value: ref.watch(printBillProvider),
                  onChanged: (bool? value) async{
                    ref.read(printBillProvider.notifier).setPrintBill(value??false);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: CheckboxListTile(
                  activeColor: const Color(0xFF1976D2),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text('Cetak Invoice' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text('Slip Invoice', style: const TextStyle(fontSize: 12), maxLines: 2,),
                  value: ref.watch(printInvoiceProvider),
                  onChanged: (bool? value) async{
                    ref.read(printInvoiceProvider.notifier).setPrintInvoice(value??false);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: CheckboxListTile(
                  activeColor: const Color(0xFF1976D2),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text('Cetak Logo' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text('Cetak logo pada invoice', style: const TextStyle(fontSize: 12), maxLines: 2,),
                  value: ref.watch(printLogoProvider),
                  onChanged: (bool? value) async{
                    ref.read(printLogoProvider.notifier).setPrintLogo(value??false);
                  },
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}