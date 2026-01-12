import 'package:auto_size_text/auto_size_text.dart';
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
      body: Container(
        decoration: BoxDecoration(
          color: CustomColorStyle.background()
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText('Tampilkan Retur Item', style:  CustomTextStyle.blackMediumSize(16),),
                SizedBox(
                  height: 12,
                  child: Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      activeTrackColor: CustomColorStyle.bluePrimary(),
                      value: ref.watch(showReturProvider),
                      onChanged: (value) {
                        ref.read(showReturProvider.notifier).setShowRetur(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Tampilkan Total Promo Item',
                style: CustomTextStyle.blackMediumSize(16),
              ),
              SizedBox(
                height: 12,
                child: Transform.scale(
                  scale: 0.75,
                  child: Switch(
                      activeTrackColor: CustomColorStyle.bluePrimary(),
                      value: ref.watch(showTotalItemPromoProvider),
                      onChanged: (value) {
                        ref.read(showTotalItemPromoProvider.notifier).setShowTotalItemPromo(value);
                      },
                    ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Tampilan promo dibawah item',
                style: CustomTextStyle.blackMediumSize(16),
              ),
              SizedBox(
                height: 12,
                child: Transform.scale(
                  scale: 0.75,
                  child: Switch(
                      activeTrackColor: CustomColorStyle.bluePrimary(),
                      value: ref.watch(showPromoBelowItemProvider),
                      onChanged: (value) {
                        ref.read(showPromoBelowItemProvider.notifier).setShowPromoBelowItem(value);
                      },
                    ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Cetak Slip Checkin',
                style: CustomTextStyle.blackMediumSize(16),
              ),
              SizedBox(
                height: 12,
                child: Transform.scale(
                  scale: 0.75,
                  child: Switch(
                      activeTrackColor: CustomColorStyle.bluePrimary(),
                      value: ref.watch(printSlipCheckinProvider),
                      onChanged: (value) {
                        ref.read(printSlipCheckinProvider.notifier).setPrintSlipCheckin(value);
                      },
                    ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Cetak Slip Order',
                style: CustomTextStyle.blackMediumSize(16),
              ),
              SizedBox(
                height: 12,
                child: Transform.scale(
                  scale: 0.75,
                  child: Switch(
                      activeTrackColor: CustomColorStyle.bluePrimary(),
                      value: ref.watch(printSlipOrderProvider),
                      onChanged: (value) {
                        ref.read(printSlipOrderProvider.notifier).setPrintSlipOrder(value);
                      },
                    ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Cetak Delivery Order',
                style: CustomTextStyle.blackMediumSize(16),
              ),
              SizedBox(
                height: 12,
                child: Transform.scale(
                  scale: 0.75,
                  child: Switch(
                      activeTrackColor: CustomColorStyle.bluePrimary(),
                      value: ref.watch(printSlipDeliveryOrderProvider),
                      onChanged: (value) {
                        ref.read(printSlipDeliveryOrderProvider.notifier).setPrintSlipDeliveryOrder(value);
                      },
                    ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          ],
        ),
      ),
    );
  }
}