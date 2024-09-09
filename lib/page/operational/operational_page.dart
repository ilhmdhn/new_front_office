import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/page/bloc/notif_bloc.dart';
import 'package:front_office_2/page/button_menu/button_menu_list.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/event_bus.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/screen_size.dart';

class OperationalPage extends StatefulWidget {
  static const nameRoute = '/operational';
  const OperationalPage({super.key});

  @override
  State<OperationalPage> createState() => _OperationalPageState();
}

class _OperationalPageState extends State<OperationalPage> {

  ApprovalCountCubit approvalCubit = ApprovalCountCubit();

  @override
  void didChangeDependencies() {
    approvalCubit.getData();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    final paddingEdgeSize = ScreenSize.getSizePercent(context, 3);
    final userData = PreferencesData.getUser();
    final widget = ButtonMenuWidget(context: context);
    eventBus.on<RefreshApprovalCount>().listen((event) {
      approvalCubit.getData();
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColorStyle.appBarBackground(),
        foregroundColor: Colors.white,
        title: Text('Operasional', style: CustomTextStyle.titleAppBar(),selectionColor: Colors.white,),
        actions: [
          IconButton(onPressed: (){}, icon: const Badge(label: Text('10') ,child: Icon(Icons.notifications,)),)
        ],
      ),
      backgroundColor: CustomColorStyle.background(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingEdgeSize),
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: BlocBuilder(
                bloc: approvalCubit,
                builder: (BuildContext ctxApproval, state){
                  if(userData.level == 'KASIR' || userData.level == 'IT'){
                    return widget.kasirLayout(state.toString());
                  } else if(userData.level == 'SUPERVISOR' || userData.level == 'KAPTEN'){
                    return widget.spvLayout(state.toString());
                  } else if(userData.level == 'SERVER'){
                    return widget.serverLayout();
                  }else if(userData.level == 'ACCOUNTING'){
                    return widget.accountingLayout(state.toString());
                  }else{
                    return const SizedBox();
                  }
                }),
              ),
            ),
          ],
        ),
      )
      );
  }
}