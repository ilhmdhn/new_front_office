import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/preferences.dart';

class PrinterStylePage extends StatefulWidget {
  static const nameRoute = '/printer-style';
  const PrinterStylePage({super.key});

  @override
  State<PrinterStylePage> createState() => _PrinterStylePageState();
}

class _PrinterStylePageState extends State<PrinterStylePage> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
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
                          value: PreferencesData.getShowReturState(),
                          onChanged: ((value) {
                            setState(() {
                              PreferencesData.setShowRetur(value);
                            });
                          })),
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
                          value: PreferencesData.getShowTotalItemPromo(),
                          onChanged: ((value) {
                            setState(() {
                              PreferencesData.setShowTotalItemPromo(value);
                            });
                          })),
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
                          value: PreferencesData.getShowPromoBelowItem(),
                          onChanged: ((value) {
                            setState(() {
                              PreferencesData.setShowPromoBelowItem(value);
                            });
                          })),
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
        ),
      )
    );
  }
}