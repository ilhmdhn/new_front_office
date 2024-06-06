import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/list.dart';

class TransferReasonPage extends StatefulWidget {
  static const nameRoute = '/transfer-reasong';
  const TransferReasonPage({super.key});

  @override
  State<TransferReasonPage> createState() => _TransferReasonPageState();
}

class _TransferReasonPageState extends State<TransferReasonPage> {

  bool isLoading = true;
  ListRoomTypeReadyResponse listRoom = ListRoomTypeReadyResponse();
  DetailCheckinResponse? detailRoom;

  void getData()async{
    // if(detailRoom.data.roomType.)
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        appBar: AppBar(
          title: Align(alignment: Alignment.centerLeft ,child: Text('Alasan Transfer Room', style: CustomTextStyle.titleAppBar(),)),
          iconTheme: const IconThemeData(
            color:  Colors.white,
          ),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText("Alasan Transfer", style: CustomTextStyle.blackStandard(),),
              CustomRadioButton(
                defaultSelected: "Overpax",
                selectedBorderColor: Colors.transparent,
                unSelectedBorderColor: CustomColorStyle.appBarBackground(),
                enableShape: true,
                shapeRadius: 0,
                spacing: 0,
                // absoluteZeroSpacing: true,
                margin: const EdgeInsets.only(top: 6, right: 3),
                horizontal: false,
                // absoluteZeroSpacing: true,
                // wrapAlignment: WrapAlignment.center,
                elevation: 0, // Menghilangkan bayangan
                buttonLables: transferReason, 
                buttonValues: transferReason,
                buttonTextStyle: ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: CustomTextStyle.blackMedium()
                ),
                autoWidth: true,
                enableButtonWrap: false,  
                padding: 0,                      
                radioButtonValue: (value){
                setState(() {
              
                });
                }, 
                unSelectedColor: Colors.white, 
                selectedColor: CustomColorStyle.appBarBackground()
              ),
              Center(
                child: Text("Room Type", style: CustomTextStyle.blackStandard(),),
              ),

              isLoading == true?
                Flexible(
                  child: Center(
                    child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
                  ),
                ):

                SizedBox()
  
              // ListView.builder(
              //   itemBuilder: )
            ],
          ),
        ),
      )
    );
  }
}