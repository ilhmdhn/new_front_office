import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_office_2/data/model/checkin_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/auth/approval_list_page.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/checkin/edit_checkin_page.dart';
import 'package:front_office_2/page/checkin/list_room_checkin_page.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/room/list_type_room.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
// import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/background_service.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:permission_handler/permission_handler.dart';

class OperationalPage extends StatelessWidget {
  static const nameRoute = '/operational';
  const OperationalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spaceCenter = ScreenSize.getSizePercent(context, 4);
    final paddingEdgeSize = ScreenSize.getSizePercent(context, 3);
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final userData = PreferencesData.getUser();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColorStyle.appBarBackground(),
        foregroundColor: Colors.white,
        title: Text('Operasional', style: CustomTextStyle.titleAppBar(),selectionColor: Colors.white,),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications))
        ],
      ),
      backgroundColor: CustomColorStyle.background(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingEdgeSize),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 55,
                  child: CircleAvatar(
                    backgroundImage: Image.asset('assets/icon/user.png').image,
                  ),
                ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userData.userId??'No Named', style: CustomTextStyle.blackMedium()),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black,
                  ),
                  Text(userData.level??'Unknown', style: CustomTextStyle.blackMedium()),
                ],
              ),
            )
              ],
            ),
            SizedBox(height: spaceCenter,),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        InkWell(
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
                                  child: Image.asset('assets/menu_icon/karaoke.png')
                                ),
                              SizedBox(
                                width: widthTextButton,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                  child: Center(
                                    child: AutoSizeText('Checkin', style: CustomTextStyle.blackMediumSize(21), minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ),
                                )),
                              SizedBox(
                                width: widthArrowButton,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                              SizedBox(
                                width: spacerpaddingButton,
                              )
                            ]),
                          ),
                          onTap: ()async{
                            String? result = await showQRScannerDialog(context);
                            if(isNotNullOrEmpty(result)){
                              // showToastWarning(result.toString());
                              final loginResult = await ApiRequest().cekMember(result.toString());
                              if(loginResult.state != true){
                                showToastWarning('gak sukses ${loginResult.message}');
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
                        ),
                        SizedBox(width: spaceCenter,),
                        Container(
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
                        ),      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: 83,
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
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 1);
                            },
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
                                  flex: 15,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                    child: Center(child: AutoSizeText('Edit Room Checkin', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  )),
                                SizedBox(
                                  width: widthArrowButton,
                                  child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                                SizedBox(
                                  width: spacerpaddingButton,
                                )
                              ]),
                          ),
                          )
                        ),
                        ],
                    ),
                    
                    const SizedBox(height: 16,),
                    SizedBox(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, RoomCheckinListPage.nameRoute, arguments: 2);
                            },
                            child: Container(
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
                                    child: Image.asset('assets/menu_icon/extend.png')
                                  ),
                                  SizedBox(
                                    width: widthTextButton,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                      child: Center(child: AutoSizeText('Extend',  style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    )
                                  ),
                                  SizedBox(
                                    width: widthArrowButton,
                                    child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                                  SizedBox(width: spacerpaddingButton)
                                ]
                              ),
                            ),
                          ),
                          SizedBox(width: spaceCenter,),
                          Container(
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
                                    child: Image.asset('assets/menu_icon/change.png')
                                  ),
                                SizedBox(
                                  width: widthTextButton,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                    child: Center(child: AutoSizeText('Transfer', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  )),
                                SizedBox(
                                  width: widthArrowButton,
                                  child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                                SizedBox(
                                  width: spacerpaddingButton,
                                )
                              ]),
                            ),],
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Container(
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
                                  child: Image.asset('assets/menu_icon/fnb.png')
                                ),
                              SizedBox(
                                width: widthTextButton,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                  child: Center(child: AutoSizeText('Order', style: CustomTextStyle.blackMediumSize(21), minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                )),
                              SizedBox(
                                width: widthArrowButton,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                              SizedBox(
                                width: spacerpaddingButton,
                              )
                            ]
                          ),
                        ),
                        SizedBox(width: spaceCenter,),
                        Container(
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
                                  child: Center(child: AutoSizeText('Bayar', style: CustomTextStyle.blackMediumSize(21), minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                )),
                              SizedBox(
                                width: widthArrowButton,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                              SizedBox(
                                width: spacerpaddingButton,
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Container(
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
                                child: Image.asset('assets/menu_icon/checkout.png')
                              ),
                              SizedBox(
                                width: widthTextButton,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                  child: Center(child: AutoSizeText('Checkout', style: CustomTextStyle.blackMediumSize(21), maxLines: 1, minFontSize: 9,)),
                                )
                              ),
                              SizedBox(
                                width: widthArrowButton,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                              SizedBox(
                                width: spacerpaddingButton,
                              )
                            ]
                          ),
                        ),
                        SizedBox(width: spaceCenter,),
                        Container(
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
                                child: Image.asset('assets/menu_icon/clean.png')
                              ),
                              SizedBox(
                                width: widthTextButton,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                  child: Center(child: AutoSizeText('Clean', style: CustomTextStyle.blackMediumSize(21), minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                )
                              ),
                              SizedBox(
                                width: widthArrowButton,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                              SizedBox(
                                width: spacerpaddingButton,
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Container(
                          width: widthButton,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          height: 83,
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
                                  child: Image.asset('assets/menu_icon/room_checkin.png')
                                ),
                              SizedBox(
                                width: widthTextButton,
                                child: InkWell(
                                  onTap: ()async{
                                    await Permission.phone.request();
                                    // PreferencesData.clearUser();
                                    // Navigator.pushNamedAndRemoveUntil(context, LoginPage.nameRoute, (route) => false);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                    child: Center(child: AutoSizeText('Checkin Info', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 2, overflow: TextOverflow.ellipsis)),
                                  ),
                                )),
                              SizedBox(
                                width: widthArrowButton,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                              SizedBox(
                                width: spacerpaddingButton,
                              )
                            ]
                          ),
                        ),
                        SizedBox(width: spaceCenter,),
                        Container(
                          width: widthButton,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          height: 83,
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
                                child: Image.asset('assets/menu_icon/list_reservation.png')
                              ),
                              SizedBox(
                                width: widthTextButton,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                  child: Center(child: AutoSizeText('List Reservasi', style: CustomTextStyle.blackMediumSize(21), minFontSize: 9, maxLines: 2, overflow: TextOverflow.ellipsis)),
                                )),
                              SizedBox(
                                width: widthArrowButton,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                              SizedBox(
                                width: spacerpaddingButton,
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, ApprovalListPage.nameRoute);
                        },
                        child: Container(
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
                                  child: Image.asset('assets/menu_icon/fingeprint.png')
                                ),
                              SizedBox(
                                width: widthTextButton,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingButtonText),
                                  child: Center(child: AutoSizeText('Approval', style: CustomTextStyle.blackMediumSize(21),  minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                )),
                              SizedBox(
                                width: widthArrowButton,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                              SizedBox(
                                width: spacerpaddingButton,
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                  
                  ]),
              ),
            )
            ],
        ),
      ),
    );
  }
}