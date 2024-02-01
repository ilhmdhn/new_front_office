import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:graphic/graphic.dart';

class MySalesPage extends StatelessWidget {
  static const nameRoute = '/MySales';
  const MySalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color:  Colors.white, //change your color here
          ),
          title: Text('Sales Report', style: CustomTextStyle.titleAppBar()),
          centerTitle: true,
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: DefaultTabController(
          length: 3, // Jumlah tab
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Daily'),
                  Tab(text: 'Weekly'),
                  Tab(text: 'Monthly'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [  
                  SizedBox(
                      width: double.infinity,
                      child: Chart(  data: const [
                        { 'genre': 'a', 'sold': 1 },
                        { 'genre': 'b', 'sold': 2 },
                        { 'genre': 'c', 'sold': 3 },
                        { 'genre': 'd', 'sold': 4 },
                        { 'genre': 'e', 'sold': 5 },
                        { 'genre': 'f', 'sold': 6 },
                        { 'genre': 'g', 'sold': 7 },
                        { 'genre': 'h', 'sold': 8 },
                        { 'genre': 'i', 'sold': 9 },
                        { 'genre': 'j', 'sold': 10 },
                        { 'genre': 'k', 'sold': 11 },
                        { 'genre': 'l', 'sold': 12 },
                      ],

                      variables: {
                        'genre': Variable(accessor: (Map map) => map['genre'] as String,),
                        'sold': Variable(accessor: (Map map) => map['sold'] as num,
                        ),
                      },    
                      marks: [IntervalMark()],
                      axes: [
                        Defaults.horizontalAxis,
                        Defaults.verticalAxis,
                      ],),
                    ),
                    
                    SizedBox(
                      width: double.infinity,
                      child: Text('ANU 2'),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text('ANU 3'),
                    )
                    // Isi dari tab 3
                  ],
                ),
              ),
            ],
          ),
          )
      ),
    );
  }    
}