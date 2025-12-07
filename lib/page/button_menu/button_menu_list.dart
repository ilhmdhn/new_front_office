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
import 'package:front_office_2/tools/orientation.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';

class ButtonMenuWidget{
  final BuildContext context;
  ButtonMenuWidget({required this.context});
  final myGroup = AutoSizeGroup();
  
  Widget kasirLayout(String approvalCount){
    final isPotrait = isVertical(context);
    final widthButton = ScreenSize.getSizePercent(context, 46);
    final widthButtonLandscape = ScreenSize.getSizePercent(context, 30);
    final spaceCenter = ScreenSize.getSizePercent(context, 2);
    final widthRow = ScreenSize.getSizePercent(context, 94);

    return
    isPotrait?
    Column(
      children: [
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                height: isPotrait == true? 68:null,
                child: checkin()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                height: isPotrait == true? 68:null,
                child: checkinReservation())
            ],
        ),
        ),
        const SizedBox(height: 6,),
        SizedBox(
          height: isPotrait == true? 68:null,
          width: widthRow,
          child: editCheckin(),
        ),
        const SizedBox(height: 6,),
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
        const SizedBox(height: 6,),
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
        const SizedBox(height: 6,),
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
        const SizedBox(height: 6,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButton,
                height: isPotrait == true? 68:null,
                child: checkinInfo()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                height: isPotrait == true? 68:null,
                child: reservationList())
            ],
        ),
        )
      ],
    ):Column(
      children: [
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButtonLandscape,
                height: isPotrait == true? 68:null,
                child: checkin()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButtonLandscape,
                height: isPotrait == true? 68:null,
                child: checkinReservation()
              ),
              SizedBox(width: spaceCenter,),
              SizedBox(
                height: isPotrait == true? 68:null,
                width: widthButtonLandscape,
                child: editCheckin(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButtonLandscape,
                height: isPotrait == true? 68:null,
                child: bill()),
              SizedBox(width: spaceCenter,)
            ],
          ),
        ),
        const SizedBox(height: 9,),
        SizedBox(
          width: widthRow,
          child: Row(
            children: [
              SizedBox(
                width: widthButtonLandscape,
                height: isPotrait == true? 68:null,
                child: checkinInfo()),
              SizedBox(width: spaceCenter,)
            ],
          ),
        ),
      ],
    );
  }

  Widget accountingLayout(String approvalCount) {
    final isPotrait = isVertical(context);
    final widthButton = ScreenSize.getSizePercent(context, 46);
    final widthButtonLandscape = ScreenSize.getSizePercent(context, 30);
    final spaceCenter = ScreenSize.getSizePercent(context, 2);
    final widthRow = ScreenSize.getSizePercent(context, 94);

    return isPotrait
        ? Column(
            children: [
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(
                        width: widthButton,
                        height: isPotrait == true ? 83 : null,
                        child: checkin()),
                    SizedBox(
                      width: spaceCenter,
                    ),
                    SizedBox(
                        width: widthButton,
                        height: isPotrait == true ? 83 : null,
                        child: checkinReservation())
       
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: isPotrait == true ? 83 : null,
                width: widthRow,
                child: editCheckin(),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(width: widthButton, child: extend()),
                    SizedBox(
                      width: spaceCenter,
                    ),
                    SizedBox(width: widthButton, child: transfer())
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(width: widthButton, child: order()),
                    SizedBox(
                      width: spaceCenter,
                    ),
                    SizedBox(width: widthButton, child: bill())
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(width: widthButton, child: checkout()),
                    SizedBox(
                      width: spaceCenter,
                    ),
                    SizedBox(width: widthButton, child: clean())
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(
                        width: widthButton,
                        height: isPotrait == true ? 83 : null,
                        child: checkinInfo()),
                    SizedBox(
                      width: spaceCenter,
                    ),
                    SizedBox(
                        width: widthButton,
                        height: isPotrait == true ? 83 : null,
                        child: reservationList())
                  ],
                ),
              ),
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(
                        width: widthButton, child: approval(approvalCount)),
                    SizedBox(
                      width: spaceCenter,
                    ),
                    // SizedBox(
                    //   width: widthButton,
                    //   height: isPotrait == true? 83:null,
                    //   child: checkinReservation())
                  ],
                ),
              ),
            ],
          )
        : Column(
            children: [
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(
                        width: widthButtonLandscape,
                        height: isPotrait == true ? 83 : null,
                        child: checkin()),
                    SizedBox(
                      width: spaceCenter,
                    ),
                    SizedBox(
                        width: widthButtonLandscape,
                        height: isPotrait == true ? 83 : null,
                        child: checkinReservation()),
                    SizedBox(
                      width: spaceCenter,
                    ),
                    SizedBox(
                      height: isPotrait == true ? 83 : null,
                      width: widthButtonLandscape,
                      child: editCheckin(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(
                        width: widthButtonLandscape,
                        height: isPotrait == true ? 83 : null,
                        child: bill()),
                    SizedBox(
                      width: spaceCenter,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: widthRow,
                child: Row(
                  children: [
                    SizedBox(
                        width: widthButtonLandscape,
                        height: isPotrait == true ? 83 : null,
                        child: checkinInfo()),
                    SizedBox(
                      width: spaceCenter,
                    )
                  ],
                ),
              ),
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
              //   height: isPotrait == true? 83:null,
              //   child: checkinReservation())
            ],
        ),
        ),
       /* const SizedBox(height: 8,),
        SizedBox(
          height: isPotrait == true? 83:null,
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
                height: isPotrait == true? 83:null,
                child: checkinInfo()),
              SizedBox(width: spaceCenter,),
              SizedBox(
                width: widthButton,
                height: isPotrait == true? 83:null,
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
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 2);
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final widthArrowButton = ScreenSize.getSizePercent(context, 2.5);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
            child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  ),
                ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: isPotrait? widthIconButton: widthIconButtonLandscape,
                  height: isPotrait? widthIconButton: widthIconButtonLandscape,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset('assets/menu_icon/karaoke.png', fit: BoxFit.contain,)
                ),
                Expanded(
                  child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                  child: AutoSizeText('Checkin', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600), minFontSize: 12, wrapWords: false,maxLines: 1),
                  )
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
                ),
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
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        showToastWarning('Checkin Reservation is coming soon');
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.purple.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/reservation.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('Checkin Reservasi', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 11, wrapWords: true, softWrap: true, maxLines: 2,),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget editCheckin(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 1);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/edit_checkin.png', fit: BoxFit.contain,)
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: Center(child: AutoSizeText('Edit Room Checkin', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false,maxLines: 2,)),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget extend(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 2);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade400, Colors.teal.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/extend.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('Duration', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false,maxLines: 1),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget transfer(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 3);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade400, Colors.indigo.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/change.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('Transfer', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false,maxLines: 1),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget order(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 4);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/fnb.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('Order', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false,maxLines: 1),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget bill(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 5);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade400, Colors.pink.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/bill.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('Bayar', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false,maxLines: 1),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget checkout(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 6);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange.shade400, Colors.deepOrange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/checkout.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('Checkout', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false, softWrap: false ,maxLines: 1),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget clean(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 7);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan.shade400, Colors.cyan.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/clean.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('Clean', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false,maxLines: 1),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget checkinInfo(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: ()async{
        showToastWarning('Checkin Info Cooming Soon');
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade400, Colors.amber.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/room_checkin.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('Checkin Info', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false,maxLines: 2),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget reservationList(){
    final widthIconButton = ScreenSize.getSizePercent(context, 8);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 4);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        showToastWarning('List Reservation is Cooming Soon');
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isPotrait? widthIconButton: widthIconButtonLandscape,
              height: isPotrait? widthIconButton: widthIconButtonLandscape,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/menu_icon/list_reservation.png', fit: BoxFit.contain,)
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: paddingButtonText + 4),
                child: AutoSizeText('List Reservasi', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),  minFontSize: 12, wrapWords: false,maxLines: 2),
              )),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,)
            ),
          ]),
      ),
    );
  }

  Widget approval(String notif){
    // final widthButton = ScreenSize.getSizePercent(context, 45);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthIconButtonLandscape = ScreenSize.getSizePercent(context, 5);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    int? notifCount = int.tryParse(notif);
    notifCount ??= 0;
    final isPotrait = isVertical(context);

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, ApprovalListPage.nameRoute);
      },
      child: Badge(
        label: Text(notifCount.toString()),
        isLabelVisible: notifCount>0?true:false,
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