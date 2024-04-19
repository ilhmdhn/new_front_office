import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/page/bloc/notif_bloc.dart';
import 'package:front_office_2/page/button_menu/button_menu_list.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/screen_size.dart';

class OperationalPage extends StatelessWidget {
  static const nameRoute = '/operational';
  const OperationalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingEdgeSize = ScreenSize.getSizePercent(context, 3);
    final userData = PreferencesData.getUser();
    ApprovalCountCubit approvalCubit = ApprovalCountCubit();
    
    final widget = ButtonMenuWidget(context: context);
    approvalCubit.getData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColorStyle.appBarBackground(),
        foregroundColor: Colors.white,
        title: Text('Operasional', style: CustomTextStyle.titleAppBar(),selectionColor: Colors.white,),
        actions: [
          IconButton(onPressed: (){}, icon: const Badge(label: Text('10') ,child: const Icon(Icons.notifications,)),)
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
            const SizedBox(height: 16),
            BlocBuilder(
            bloc: approvalCubit,
            builder: (BuildContext ctxApproval, state){
              return widget.kasirLayout(state.toString());
            }),
          ],
        ),
      )
      );
  }
}