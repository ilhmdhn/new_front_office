import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/page/bloc/notif_bloc.dart';
import 'package:front_office_2/page/button_menu/button_menu_list.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/event_bus.dart';
import 'package:front_office_2/tools/preferences.dart';

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
    final userData = PreferencesData.getUser();

    final widget = ButtonMenuWidget(context: context);

    eventBus.on<RefreshApprovalCount>().listen((event) {
      approvalCubit.getData();
    });
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColorStyle.background(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 16,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText('Halo, ${userData.userId}', 
                          style: CustomTextStyle.blackBoldSize(20),
                          maxLines: 1,
                          minFontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(userData.level??'', 
                          style: CustomTextStyle.blackSize(11),
                          maxLines: 1,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                    } else if(userData.level == 'SERVER' || userData.level == 'BAR'){
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
        ),
      )
      );
  }
}