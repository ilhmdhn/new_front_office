import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/orientation.dart';

class RoomPage extends StatefulWidget {
  static const nameRoute = '/room';
  const RoomPage({super.key});
  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  int existPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddOnWidget.appBar(context, 'Kamar'),
      body: 
        isVertical(context)?
        Column():
        Column(
          children: [
            const SizedBox(height: 6,),
            Row(
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      existPage = 0;
                    });
                  },
                  child: Container(
                    decoration: existPage == 0
                            ? CustomContainerStyle.blueButton()
                            : CustomContainerStyle.greyButton(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    child: Text('Daftar Kamar', style: existPage == 0
                              ? CustomTextStyle.whiteStandard()
                              : CustomTextStyle.blackStandard(),
                        ),
                  ),
                ),
                const SizedBox(width: 6,),
                InkWell(
                      onTap: () {
                        setState(() {
                          existPage = 1;
                        });
                      },
                  child: Container(
                    decoration: existPage == 1
                            ? CustomContainerStyle.blueButton()
                            : CustomContainerStyle.greyButton(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    child: Text('Reservasi',
                          style: existPage == 1
                              ? CustomTextStyle.whiteStandard()
                              : CustomTextStyle.blackStandard(),
                        ),
                  ),
                ),
                    const SizedBox(
                      width: 6,
                    ),
                InkWell(
                      onTap: () {
                        setState(() {
                          existPage = 2;
                        });
                      },
                  child: Container(
                    decoration: existPage == 2 ?CustomContainerStyle.blueButton() : CustomContainerStyle.greyButton(),
                    padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 3),
                    child: Text('Tamu', style: existPage == 2 ? CustomTextStyle.whiteStandard() : CustomTextStyle.blackStandard(),),
                  ),
                ),
                    const SizedBox(
                      width: 6,
                    ),
                InkWell(
                      onTap: () {
                        setState(() {
                          existPage = 3;
                        });
                      },
                  child: Container(
                    decoration: existPage == 3
                            ? CustomContainerStyle.blueButton()
                            : CustomContainerStyle.greyButton(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    child: Text('Chat',
                          style: existPage == 3
                              ? CustomTextStyle.whiteStandard()
                              : CustomTextStyle.blackStandard(),
                        ),
                  ),
                )
              ],
            ),
            const Expanded(
              child: SizedBox()),
          ],
        )
      ,
    );
  }
}