import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class ReservationList extends StatefulWidget {
  static const nameRoute = '/reservation-list';
  const ReservationList({super.key});

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {

  TextEditingController etSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(flex: 1, child: AutoSizeText('List Reservation', style: CustomTextStyle.blackStandard(),)),
              Flexible(flex: 1, child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 170,
                          height: 25,
                          child: SearchBar(
                            controller: etSearch,
                            leading: Icon(Icons.search),
                            hintText: 'Search',
                          )
                        ),
                        const SizedBox(width: 12,),
                        Container(
                          decoration: CustomContainerStyle.cancelList(),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          child: Row(
                            children: [
                              Icon(Icons.add_box_rounded, color: Colors.grey.shade300),
                              Text('New Reservation', style: CustomTextStyle.whiteSize(14),)
                            ],
                          ),),
                      ],
                    ),
                  )
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}