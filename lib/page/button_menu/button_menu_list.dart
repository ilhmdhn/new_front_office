import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/checkin_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/auth/approval_list_page.dart';
import 'package:front_office_2/page/checkin/list_room_checkin_page.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/room/list_type_room.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';

class ButtonMenuWidget{
  final BuildContext context;
  ButtonMenuWidget({required this.context});

  Widget checkin(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    return InkWell(
            child: Container(
            height: 83,
            width: widthButton,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                  ),
                ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: spacerpaddingButton,
                ),
                SizedBox(
                  width: widthIconButton,
                  child: Image.asset('assets/menu_icon/karaoke.png')
                ),
                SizedBox(
                  width: widthTextButton,
                  child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                  child: Center(
                    child: AutoSizeText('Checkin', style: CustomTextStyle.blackMediumSize(21), minFontSize: 9, maxLines: 1),),
                  )
                ),
                SizedBox(
                  width: widthArrowButton,
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                SizedBox(
                    width: spacerpaddingButton,
                )
              ]
            ),),
            onTap: ()async{
              String? result = await showQRScannerDialog(context);
              if(isNotNullOrEmpty(result)){
                final loginResult = await ApiRequest().cekMember(result.toString());
                if(loginResult.state != true){
                  showToastWarning(loginResult.message??'Gagal cek member');
                }else{
                  if(context.mounted){
                    final checkinParams = CheckinParams(
                            memberName: loginResult.data?.fullName??'no name',
                            memberCode: loginResult.data?.memberCode??'undefined'
                    );
                    Navigator.pushNamed(context, ListRoomTypePage.nameRoute, arguments: checkinParams);
                  }
                }
              }
            },
        );
  }

  Widget checkinReservation(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    
    return InkWell(
      onTap: (){
        showToastWarning('Checkin Reservation is coming soon');
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white, // Warna background
          borderRadius: BorderRadius.circular(10), // Bentuk border
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Warna shadow
              spreadRadius: 3, // Radius penyebaran shadow
              blurRadius: 7, // Radius blur shadow
              offset: const Offset(0, 3), // Offset shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/reservation.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Checkin Reservasi', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 2, overflow: TextOverflow.ellipsis)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

  Widget editCheckin(){

    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 1);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white, // Warna background
          borderRadius: BorderRadius.circular(10), // Bentuk border
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Warna shadow
              spreadRadius: 3, // Radius penyebaran shadow
              blurRadius: 7, // Radius blur shadow
              offset: const Offset(0, 3), // Offset shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/edit_checkin.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Edit Checkin', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 2, overflow: TextOverflow.ellipsis)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

  Widget extend(){

    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 2);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/extend.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Extend', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

  Widget transfer(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 3);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/change.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Checkouts', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

  Widget order(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 4);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/fnb.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Order', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

  Widget bill(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 5);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/bill.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Order', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }
  
  Widget checkout(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 4);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/checkout.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Checkout', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

  Widget clean(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 5);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/clean.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Clean', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

  Widget checkinInfo(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 6);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/room_checkin.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Checkin Info', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 2)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

  Widget reservationList(){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 7);
      },
      child: Container(
        height: 83,
          width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: spacerpaddingButton,
            ),
            SizedBox(
              width: widthIconButton,
                child: Image.asset('assets/menu_icon/list_reservation.png')
              ),
            SizedBox(
              width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('List Reservasi', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 2)),
              )),
            SizedBox(
              width: widthArrowButton,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
            SizedBox(
              width: spacerpaddingButton,
            )
          ]),
      ),
    );
  }

   Widget approval(int notif){
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    if(isNullOrEmpty(notif)){
      notif = 0;
    }
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, ApprovalListPage.nameRoute);
      },
      child: Badge(
        label: Text(notif.toString()),
        isLabelVisible: notif>0?true:false,
        child: Container(
          height: 83,
            width: widthButton,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: spacerpaddingButton,
              ),
              SizedBox(
                width: widthIconButton,
                  child: Image.asset('assets/menu_icon/fingeprint.png')
                ),
              SizedBox(
                width: widthTextButton,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                  child: Center(child: AutoSizeText('Approval', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1)),
                )),
              SizedBox(
                width: widthArrowButton,
                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
              SizedBox(
                width: spacerpaddingButton,
              )
            ]),
        ),
      ),
    );
  }
}