import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/checkin_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/auth/approval_list_page.dart';
import 'package:front_office_2/page/checkin/checkin_page.dart';
import 'package:front_office_2/page/checkin/list_room_checkin_page.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/room/list_type_room.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/orientation.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';

class ButtonMenuWidget{
  final BuildContext context;
  ButtonMenuWidget({required this.context});
  final myGroup = AutoSizeGroup();
  
  Widget kasirLayout(String approvalCount){
    return Column(
      children: [
        buildGridMenu(
          'Operasional',
          2, 
          [              
            checkinPage(),
            editCheckin(),
            extend(),
            transfer(),
            order(),
            bill(),
            checkout(),
            clean(),
            checkinOld(),
          ]
        ),
      ],
    );
  }

  Widget accountingLayout(String approvalCount) {
    return Column(
      children: [
        buildGridMenu(
          'Operasional',
          2, 
          [  
            checkinPage(),                
            editCheckin(),
            extend(),
            transfer(),
            order(),
            bill(),
            checkout(),
            clean(),
            // checkinOld()
            checkinPage()
          ]
        ),
        SizedBox(height: 12,),
        buildGridMenu(
          'Verification',
          2, 
          [                  
            approval(approvalCount)
          ]
        ),
      ],
    );
  }

  Widget serverLayout(){
    return Column(
      children: [
        buildGridMenu(
          'Operasional',
          2, 
          [
            order(),
            bill(),
            clean()
          ]
        ),
      ]
    );
  }

  Widget spvLayout(String approvalCount){
    return Column(
      children: [
        buildGridMenu(
          'Operasional',
          2, 
          [  
            checkinPage(),     
            editCheckin(),
            extend(),
            transfer(),
            order(),
            bill(),
            checkout(),
            clean(),
            checkinOld()
          ]
        ),
        SizedBox(height: 12,),
        buildGridMenu(
          'Verification',
          2, 
          [                  
            approval(approvalCount)
          ]
        ),
      ],
    );
  }

  Widget checkinOld(){
    return InkWell(
        child: Container(
          height: 50,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
            child: AutoSizeText('Checkin Old', 
            style: CustomTextStyle.whiteStandard(), 
              minFontSize: 12, 
              maxLines: 1, 
              textAlign: TextAlign.center, ),
          ),
        ),
        // child: itemButton('assets/menu_icon/karaoke.png', 'Checkin Old')),
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

  Widget checkinPage(){
    return InkWell(
      child: itemButton('assets/menu_icon/karaoke.png', 'Checkin'),
            onTap: (){
              Navigator.pushNamed(context, CheckinPage.nameRoute);
            },
        );
  }


  Widget checkinReservation(){
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 5);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        showToastWarning('Checkin Reservation is coming soon');
      },
      child: Container(
        // height: isPotrait == true? 83:null,
          // width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white, // Warna background
          borderRadius: BorderRadius.circular(10), // Bentuk border
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2), // Warna shadow
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
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
                child: Image.asset('assets/menu_icon/reservation.png')
              ),
            Expanded(
              // width: widthTextButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                child: AutoSizeText('Checkin Reservasi', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 13, wrapWords: true, softWrap: true, maxLines: 2,),
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
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 1);
      },
      child: itemButton('assets/menu_icon/edit_checkin.png', 'Edit Room Checkin'),
    );
  }

  Widget extend(){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 2);
      },
      child: itemButton('assets/menu_icon/extend.png', 'Duration'),
    );
  }

  Widget transfer(){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 3);
      },
      child: itemButton('assets/menu_icon/change.png', 'Transfer Room')
    );
  }

  Widget order(){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 4);
      },
      child: itemButton('assets/menu_icon/fnb.png', 'Order')
    );
  }

  Widget bill(){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 5);
      },
      child: itemButton('assets/menu_icon/bill.png', 'Bayar'),
    );
  }
  
  Widget checkout(){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 6);
      },
      child: itemButton('assets/menu_icon/checkout.png', 'Checkout')
    );
  }

  Widget clean(){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 7);
      },
      child: itemButton('assets/menu_icon/clean.png', 'Clean'),
    );
  }

  Widget checkinInfo(){
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 5);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    final isPotrait = isVertical(context);

    return InkWell(
      onTap: ()async{
        showToastWarning('Checkin Info Cooming Soon');
        // Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 8);
      },
      child: Container(
        // height: isPotrait == true? 83:null,
          // width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
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
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
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
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 5);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);

    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        showToastWarning('List Reservation is Cooming Soon');
      },
      child: Container(
        // height: isPotrait == true? 83:null,
          // width: widthButton,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
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
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
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
    int? notifCount = int.tryParse(notif);
    notifCount ??= 0;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, ApprovalListPage.nameRoute);
      },
      child: Badge(
        label: Text(notifCount.toString()),
        isLabelVisible: notifCount>0?true:false,
        child: itemButton('assets/menu_icon/fingeprint.png', 'Approval')
      ),
    );
  }

  Widget itemButton(String image, String title){
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 15),
          Image.asset(image, width: 39, height: 39,),
          const SizedBox(width: 4,),
          Flexible(
            fit: FlexFit.tight,
            child: AutoSizeText(
              title, 
              style: CustomTextStyle.blackMedium(), 
              minFontSize: 12, 
              maxLines: 2, 
              textAlign: TextAlign.start
            )
          ),
          const SizedBox(width: 4,),
          SizedBox(
            width: 10,
            child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget buildGridMenu(String title, int columnCount, List<Widget> menuItems) {
    List<Widget> rows = [];
    List<Widget> currentRow = [];

    for (int i = 0; i < menuItems.length; i++) {
      Widget item;

      if (i % columnCount == 0) {
        item = Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.only(right: 3),
            child: Center(child: menuItems[i]),
          ),
        );
      } else if ((i + 1) % columnCount == 0) {
        item = Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.only(left: 3),
            child: Center(child: menuItems[i]),
          ),
        );
      } else {
        item = Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Center(child: menuItems[i]),
          ),
        );
      }

      currentRow.add(item);

      if ((i + 1) % columnCount == 0 || i == menuItems.length - 1) {
        // Add empty expanded widgets to fill the row if needed
        while (currentRow.length < columnCount) {
          currentRow.add(const Expanded(child: SizedBox()));
        }
        
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: currentRow,
          ),
        );
        currentRow = [];
        if (i != menuItems.length - 1) {
          rows.add(const SizedBox(height: 12));
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(145), 
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Text(title, style: CustomTextStyle.blackBoldSize(16),),
          ),
          ...rows
          ],
      ),
    );
  }
}