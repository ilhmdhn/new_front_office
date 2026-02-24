import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/page/bloc/notif_bloc.dart';
import 'package:front_office_2/page/button_menu/button_menu_list.dart';
import 'package:front_office_2/page/setting/printer/print_job_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/event_bus.dart';

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
    final userData = GlobalProviders.read(userProvider);

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        AutoSizeText(userData.level,
                          style: CustomTextStyle.blackSize(11),
                          maxLines: 1,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, PrintJobPage.routeName);
                    },
                    padding: EdgeInsets.zero,
                    icon: Badge(
                      label: Text(
                        '1',
                        style: CustomTextStyle.whiteSize(11),
                      ),
                      offset: Offset(4, -4),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: CustomColorStyle.bluePrimary().withOpacity(0.12),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: CustomColorStyle.bluePrimary().withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.print_disabled_outlined,
                          color: CustomColorStyle.bluePrimary(),
                          size: 22,
                        ),
                      ),
                    ),
                  )
                  /*
                  IconButton(onPressed: (){}, icon: Badge(
                    label: Text('1', style: CustomTextStyle.whiteSize(14)),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: CustomColorStyle.bluePrimary(),
                        borderRadius: BorderRadius.circular(24)
                      ),
                      child: Icon(Icons.print_disabled_outlined, color: Colors.white,)
                    ),
                  ), color: CustomColorStyle.bluePrimary(),)*/
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: BlocBuilder(
                  bloc: approvalCubit,
                  builder: (BuildContext ctxApproval, state){
                    if(userData.level == 'KASIR'){
                      return widget.kasirLayout(state.toString());
                    } else if(userData.level == 'SUPERVISOR' || userData.level == 'KAPTEN'){
                      return widget.spvLayout(state.toString());
                    } else if(userData.level == 'SERVER' || userData.level == 'BAR'  || userData.level == 'IT'){
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