import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:front_office_2/tools/orientation.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  static const nameRoute = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
  double spaceHorizontal = ScreenSize.getSizePercent(context, 1);
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AddOnWidget.appBar(context, 'Dashboard', notifCount: 19),
      body: 
      isVertical(context)?
      const Column():
      Padding(
        padding: EdgeInsets.symmetric(horizontal: spaceHorizontal, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: CustomTextStyle.blackMediumSize(21)),
            Text('Ringkasan checkin yang sedang berlangsung', style: CustomTextStyle.blackStandard()),
            const SizedBox(height: 12,),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: ScreenSize.getSizePercent(context, 19),
                      decoration: BoxDecoration(
                      color: CustomColorStyle.secondaryBackground(),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
                      child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 56,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.food_bank, color: Colors.red, size: 26,),
                                        Expanded(
                                          child: AutoSizeText('Antrian Order', style: GoogleFonts.poppins(), minFontSize: 14, maxFontSize: 16, maxLines: 2))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6,),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: 10,
                                      itemBuilder: (ctx, index){
                                        return Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              AutoSizeText('ROOM 10', style: CustomTextStyle.blackMediumSize(14), minFontSize: 9, maxFontSize: 16,),
                                            ],
                                          ));
                                      }),
                                  )
                                ],
                              ),
                    ),
                    SizedBox(width: spaceHorizontal,),
                    Container(
                              width: ScreenSize.getSizePercent(context, 19),
                              decoration: BoxDecoration(
                                  color: CustomColorStyle.secondaryBackground(),
                                  borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 56,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.room_service,
                                          color: Colors.red,
                                          size: 26,
                                        ),
                                        AutoSizeText(
                                          'Panggilan Service',
                                          style: GoogleFonts.poppins(),
                                          minFontSize: 14,
                                          maxFontSize: 16, maxLines: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey,
                                  ),Expanded(
                                    child: ListView.builder(
                                      itemCount: 10,
                                      itemBuilder: (ctx, index){
                                        return Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                                                            AutoSizeText(
                                                'ROOM 10',
                                                style: CustomTextStyle
                                                    .blackMediumSize(14),
                                                minFontSize: 9,
                                                maxFontSize: 16,
                                              ),
                                            ],
                                          ));
                                      }),
                                  )
                                ],
                              ),
                            ),
                    SizedBox(width: spaceHorizontal,),
                    Container(
                              width: ScreenSize.getSizePercent(context, 19),
                              decoration: BoxDecoration(
                                  color: CustomColorStyle.secondaryBackground(),
                                  borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 56,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.not_interested,
                                          color: Colors.red,
                                          size: 26,
                                        ),
                                        AutoSizeText(
                                          'No Food',
                                          style: GoogleFonts.poppins(),
                                          minFontSize: 14,
                                          maxFontSize: 16, maxLines: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                    SizedBox( width: spaceHorizontal,),
                    Container(
                              width: ScreenSize.getSizePercent(context, 19),
                              decoration: BoxDecoration(
                                  color: CustomColorStyle.secondaryBackground(),
                                  borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 56,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.notes,
                                          color: Colors.red,
                                          size: 26,
                                        ),
                                        AutoSizeText(
                                          'Log Transaksi',
                                          style: GoogleFonts.poppins(),
                                          minFontSize: 14,
                                          maxFontSize: 16, maxLines: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                    SizedBox(width: spaceHorizontal,),
                    Container(
                              width: ScreenSize.getSizePercent(context, 19),
                              decoration: BoxDecoration(
                                  color: CustomColorStyle.secondaryBackground(),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 56,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.timer_10_rounded,
                                          color: Colors.red,
                                          size: 26,
                                        ),
                                        AutoSizeText(
                                          'Akan Habis',
                                          style: GoogleFonts.poppins(),
                                          minFontSize: 14,
                                          maxFontSize: 16, maxLines: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12,)
          ],
        ),
      )
    );
  }
}