import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class MySalesPage extends StatelessWidget {
  static const nameRoute = '/MySales';
  const MySalesPage({super.key});
/*
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
                        { 'genre': 'b', 'sold': 5 },
                        { 'genre': 'c', 'sold': 8 },
                        { 'genre': 'd', 'sold': 2 },
                        { 'genre': 'e', 'sold': 8 },
                        { 'genre': 'f', 'sold': 1 },
                        { 'genre': 'g', 'sold': 9 },
                        { 'genre': 'h', 'sold': 4 },
                        { 'genre': 'i', 'sold': 7 },
                        { 'genre': 'j', 'sold': 2 },
                        { 'genre': 'k', 'sold': 15 },
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
*/
@override
Widget build(BuildContext context) {
    return Container();
    // return AspectRatio(
    //   aspectRatio: 1.7,
    //   child: BarChart(
    //     BarChartData(
    //       barGroups: [
    //         BarChartGroupData(
    //           x: 0,
    //           barRods: [
    //             BarChartRodData(
    //               toY: 1,
    //               color: [Colors.red],
    //             ),
    //           ],
    //         ),
    //         BarChartGroupData(
    //           x: 1,
    //           barRods: [
    //             BarChartRodData(
    //               y: 2,
    //               colors: [Colors.blue],
    //             ),
    //           ],
    //         ),
    //         BarChartGroupData(
    //           x: 2,
    //           barRods: [
    //             BarChartRodData(
    //               y: 5,
    //               colors: [Colors.green],
    //             ),
    //           ],
    //         ),
    //         BarChartGroupData(
    //           x: 3,
    //           barRods: [
    //             BarChartRodData(
    //               y: 4,
    //               colors: [Colors.yellow],
    //             ),
    //           ],
    //         ),
    //         BarChartGroupData(
    //           x: 4,
    //           barRods: [
    //             BarChartRodData(
    //               y: 6,
    //               colors: [Colors.orange],
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }}