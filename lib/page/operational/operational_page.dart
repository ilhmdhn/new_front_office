import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
// import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class OperationalPage extends StatefulWidget {
  static const nameRoute = '/operational';
  const OperationalPage({super.key});

  @override
  State<OperationalPage> createState() => _OperationalPageState();
}

class _OperationalPageState extends State<OperationalPage> {
  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('USER', style: CustomTextStyle.blackMedium()),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black,
                  ),
                  Text('ACCOUNTING', style: CustomTextStyle.blackMedium()),
                ],
              ),
            )
              ],
            ),
            const SizedBox(height: 19,),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
              /*                  Row(children: [
                      InkWell(
                        onTap: ()async{
                          String? result = await showQRScannerDialog(context);
                          if(isNotNullOrEmpty(result)){
                            showToastWarning(result.toString());
                          }
                        },
                        child: Container(
                          color: Colors.green,
                          child: const Text('CHECKIN'),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, PrinterPage.nameRoute);
                        },
                        child: Container(
                          color: Colors.green,
                          child: const Text('PRINTER'),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, LoginPage.nameRoute);
                        },
                        child: Container(
                          color: Colors.green,
                          child: const Text('LOGIN'),
                        ),
                      ) 
                    ],),*/
                    Row(
                      children: [
                        Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/karaoke.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(
                                      child: AutoSizeText('Checkin', style: CustomTextStyle.blackMediumSize(30), minFontSize: 12, maxFontSize: 30, maxLines: 1,),
                                    ),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),
                        const SizedBox(width: 12,),
                                              Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/reservation.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: AutoSizeText('Checkin Reservasi', style: CustomTextStyle.blackMediumNoSize(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/edit_checkin.png')
                                  ),
                                Expanded(
                                  flex: 15,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('Edit Room Checkin', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),
                        ],
                    ),
                    
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/extend.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('Extend', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),
                        const SizedBox(width: 12,),
                          Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/change.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('Transfer', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/fnb.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('Order', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),
                        const SizedBox(width: 12,),
                                              Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/bill.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('Bayar', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),],
                    ),
                    const SizedBox(height: 16,),
              Row(
                      children: [
                        Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/checkout.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('Checkout', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),
                        const SizedBox(width: 12,),
                                              Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/clean.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('Clean', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),],
                    ),
                                      const SizedBox(height: 16,),
              Row(
                      children: [
                        Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/room_checkin.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('Extend', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),
                        const SizedBox(width: 12,),
                                              Expanded(
                          child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: Image.asset('assets/menu_icon/list_reservation.png')
                                  ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Center(child: Text('List Reservasi', style: CustomTextStyle.blackMedium(),)),
                                  )),
                                const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                              ]),
                          ),
                          )
                        ),],
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