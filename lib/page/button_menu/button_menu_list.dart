import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/checkin_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/auth/approval_list_page.dart';
import 'package:front_office_2/page/checkin/list_room_checkin_page.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/dialog/rating_dialog.dart';
import 'package:front_office_2/page/room/list_type_room.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';

class ButtonMenuWidget{
  final BuildContext context;
  ButtonMenuWidget({required this.context});
  final myGroup = AutoSizeGroup();
  
  Widget kasirLayout(String approvalCount){
    final widthButton = ScreenSize.getSizePercent(context, 46);  
    final spaceCenter = ScreenSize.getSizePercent(context, 2);
    final widthRow = ScreenSize.getSizePercent(context, 94);

    return Column(
      children: [
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                height: 83,
                child: checkin()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                height: 83,
                child: checkinReservation())
            ],
        ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          height: 83,
          width: widthRow,
          child: editCheckin(),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: extend()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                child: transfer())
            ],
        ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: order()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                child: bill())
            ],
        ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: checkout()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                child: clean())
            ],
        ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                height: 83,
                child: checkinInfo()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                height: 83,
                child: reservationList())
            ],
        ),
        )
      ],
    );
  }

  Widget serverLayout(){
    final widthButton = ScreenSize.getSizePercent(context, 46);  
    final spaceCenter = ScreenSize.getSizePercent(context, 2);
    final widthRow = ScreenSize.getSizePercent(context, 94);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: order()),
              SizedBox(
                width: spaceCenter
              ),
              SizedBox(
                width: widthButton,
                child: bill()
              ),
            ],
          ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: clean()),
              SizedBox(
                width: spaceCenter
              ),
              SizedBox(
                width: widthButton,
              ),
            ],
          ),
        ),
      ],
    );

  }

  Widget spvLayout(String approvalCount){
    final widthButton = ScreenSize.getSizePercent(context, 46);  
    final spaceCenter = ScreenSize.getSizePercent(context, 2);
    final widthRow = ScreenSize.getSizePercent(context, 94);

    return Column(
      children: [
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: approval(approvalCount)),
              SizedBox(width: spaceCenter,),
              // SizedBox(
              //   width: widthButton,
              //   height: 83,
              //   child: checkinReservation())
            ],
        ),
        ),
       /* const SizedBox(height: 8,),
        SizedBox(
          height: 83,
          width: widthRow,
          child: editCheckin(),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: extend()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                child: transfer())
            ],
        ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: order()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                child: bill())
            ],
        ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                child: checkout()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                child: clean())
            ],
        ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                height: 83,
                child: checkinInfo()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                height: 83,
                child: reservationList())
            ],
        ),
        ),
        const SizedBox(height: 8,),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: widthButton,
            child: approval(approvalCount),
          ),
        )
    */],
    );
  }


  Widget checkin(){
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    return InkWell(
            child: Container(
            // height: 83,
            // width: widthButton,
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
                Expanded(
                  child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                  child: AutoSizeText('Checkin', style: CustomTextStyle.blackMediumSize(19), minFontSize: 14, wrapWords: false,maxLines: 1),
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
                            photo: loginResult.data?.photo??'https://adm.happypuppy.id/uploads/empty',
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
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    
    return InkWell(
      onTap: (){
        showToastWarning('Checkin Reservation is coming soon');
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Checkin Reservasi', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: true, softWrap: true,maxLines: 2,),
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

    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 1);
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Flexible(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: Center(child: AutoSizeText('Edit Room Checkin', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 1,)),
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

    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 2);
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Duration', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 1),
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
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 3);
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Transfer', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 1),
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
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 4);
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Order', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 1),
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
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 5);
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Bayar', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 1),
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
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 6);
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Checkout', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false, softWrap: false ,maxLines: 1),
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
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 7);
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Clean', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 1),
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
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        // showToastWarning('Checkin Info Cooming Soon');
        RatingDialog.viewQr(context, '');
        // Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 8);
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Checkin Info', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 2),
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
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    return InkWell(
      onTap: (){
        showToastWarning('List Reservation is Cooming Soon');
      },
      child: Container(
        // height: 83,
          // width: widthButton,
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
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('List Reservasi', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 2),
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

   Widget approval(String notif){
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    int? notifCount = int.tryParse(notif);
    notifCount ??= 0;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, ApprovalListPage.nameRoute);
      },
      child: Badge(
        label: Text(notifCount.toString()),
        isLabelVisible: notifCount>0?true:false,
        child: Container(
          // height: 83,
            // width: widthButton,
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                  child: AutoSizeText('Approval', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 1),
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