import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
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
    final isDesktopLandscape = context.isLandscape && context.isDesktop;

    eventBus.on<RefreshApprovalCount>().listen((event) {
      approvalCubit.getData();
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColorStyle.background(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktopLandscape ? 32 : 12,
            vertical: isDesktopLandscape ? 16 : 0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: isDesktopLandscape ? 8 : 16),
              _buildHeader(context, userData, isDesktopLandscape),
              SizedBox(height: isDesktopLandscape ? 24 : 16),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: BlocBuilder(
                    bloc: approvalCubit,
                    builder: (BuildContext ctxApproval, state) {
                      if (userData.level == 'KASIR') {
                        return widget.kasirLayout(state.toString());
                      } else if (userData.level == 'SUPERVISOR' || userData.level == 'KAPTEN') {
                        return widget.spvLayout(state.toString());
                      } else if (userData.level == 'SERVER' || userData.level == 'BAR' || userData.level == 'IT') {
                        return widget.serverLayout();
                      } else if (userData.level == 'ACCOUNTING') {
                        return widget.accountingLayout(state.toString());
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic userData, bool isDesktopLandscape) {
    if (isDesktopLandscape) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CustomColorStyle.bluePrimary(),
              CustomColorStyle.bluePrimary().withAlpha(200),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CustomColorStyle.bluePrimary().withAlpha(60),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(
                  userData.userId.toString().isNotEmpty
                    ? userData.userId.toString()[0].toUpperCase()
                    : 'U',
                  style: CustomTextStyle.whiteSizeMedium(24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Halo, ${userData.userId}',
                    style: CustomTextStyle.whiteSizeMedium(22),
                    maxLines: 1,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AutoSizeText(
                      userData.level,
                      style: CustomTextStyle.whiteSize(12),
                      maxLines: 1,
                      minFontSize: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            _buildPrintJobButton(context, isDesktopLandscape),
          ],
        ),
      );
    }

    // Default header untuk non-desktop
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                'Halo, ${userData.userId}',
                style: CustomTextStyle.blackBoldSize(20),
                maxLines: 1,
                minFontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
              AutoSizeText(
                userData.level,
                style: CustomTextStyle.blackSize(11),
                maxLines: 1,
                minFontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildPrintJobButton(context, isDesktopLandscape),
      ],
    );
  }

  Widget _buildPrintJobButton(BuildContext context, bool isDesktopLandscape) {
    return Consumer(
      builder: (context, ref, child) {
        final jobs = ref.watch(printJobProvider);
        if (jobs.isEmpty) {
          return const SizedBox();
        }
        return IconButton(
          onPressed: () {
            Navigator.pushNamed(context, PrintJobPage.routeName);
          },
          padding: EdgeInsets.zero,
          icon: Badge(
            label: Text(
              jobs.length.toString(),
              style: CustomTextStyle.whiteSize(11),
            ),
            offset: const Offset(4, -4),
            child: Container(
              width: isDesktopLandscape ? 52 : 48,
              height: isDesktopLandscape ? 52 : 48,
              decoration: BoxDecoration(
                color: isDesktopLandscape
                  ? Colors.white.withAlpha(50)
                  : CustomColorStyle.bluePrimary().withAlpha(12),
                borderRadius: BorderRadius.circular(26),
                border: isDesktopLandscape
                  ? null
                  : Border.all(
                      color: CustomColorStyle.bluePrimary().withAlpha(5),
                      width: 1.5,
                    ),
              ),
              child: Icon(
                Icons.print_disabled_outlined,
                color: isDesktopLandscape
                  ? Colors.white
                  : CustomColorStyle.bluePrimary(),
                size: isDesktopLandscape ? 24 : 22,
              ),
            ),
          ),
        );
      },
    );
  }
}