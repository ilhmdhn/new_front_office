import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:expand_widget/expand_widget.dart';

class DashboardPage extends StatefulWidget {
  static const nameRoute = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
                backgroundColor: CustomColorStyle.appBarBackground(),
        foregroundColor: Colors.white,
        title: Text(
          'Dashboard',
          style: CustomTextStyle.titleAppBar(),
          selectionColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
            ExpansionPanelList(
             expansionCallback: (int index, bool isExpanded) {
               setState(() {
                 _isOpen =
                     !isExpanded; // Toggle status terbuka atau tertutup
               });
             },
             children: [
               ExpansionPanel(
                 headerBuilder: (context, isExpanded) {
                   return ListTile(
                     title: Text('dul kemen'),
                     leading: Icon(Icons.ac_unit_rounded),
                   );
                 },
                 body: Column(
                   children: [
                     Icon(Icons.abc_sharp),
                     Text('aaaaaaa'),
                   ],
                 ),
                 isExpanded: _isOpen, // Mengatur status terbuka panel
               ),
             ],
                          )
        ],
      ),
    );
  }
}