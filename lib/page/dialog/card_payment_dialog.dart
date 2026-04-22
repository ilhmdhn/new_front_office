import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/page/bloc/edc_bloc.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/list.dart';

class CardPaymentDialog {

  // --- 1. FUNCTION: EDC MACHINE ---
  static Future<String?> edcMachine(BuildContext ctx) {
    String? chooseEdc;
    EdcCubit edcResponse = EdcCubit();
    edcResponse.getEdc();

    return showDialog<String?>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctxDialog) {
        final double dialogWidth = ctxDialog.isDesktop && ctxDialog.isLandscape
            ? ctxDialog.wp(35)
            : ctxDialog.isDesktop
                ? ctxDialog.wp(45)
                : ctxDialog.isLandscape
                    ? ctxDialog.wp(60)
                    : ctxDialog.wp(88);

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: dialogWidth,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  'Pilih Mesin EDC',
                  style: CustomTextStyle.titleAlertDialog(),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 8),
                BlocBuilder<EdcCubit, EdcResponse>(
                  bloc: edcResponse,
                  builder: (BuildContext ctxBloc, EdcResponse edc) {
                    if (edc.isLoading == true) {
                      return _buildLoadingState();
                    }
                    if (edc.state != true) {
                      return _buildErrorState(edc.message.toString());
                    }

                    final List<String> edcList =
                        edc.data.map((e) => e.edcName.toString()).toList();

                    final int crossAxisCount = ctxDialog.isDesktop ? 3 : 2;

                    return StatefulBuilder(
                      builder: (ctxStfl, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildGridSelector(
                              items: edcList,
                              selectedItem: chooseEdc,
                              crossAxisCount: crossAxisCount,
                              onTap: (val) => setState(() => chooseEdc = val),
                            ),
                            const SizedBox(height: 20),
                            _buildActionButtons(ctxDialog, () => chooseEdc),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 2. FUNCTION: CARD TYPE ---
  static Future<String?> cardType(BuildContext ctx) {
    String? chooseCardType;

    return showDialog<String?>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctxDialog) {
        final double dialogWidth = ctxDialog.isDesktop && ctxDialog.isLandscape
            ? ctxDialog.wp(35)
            : ctxDialog.isDesktop
                ? ctxDialog.wp(45)
                : ctxDialog.isLandscape
                    ? ctxDialog.wp(60)
                    : ctxDialog.wp(88);

        final int crossAxisCount = ctxDialog.isDesktop
            ? 3
            : ctxDialog.isLandscape
                ? 3
                : 2;

        return StatefulBuilder(
          builder: (ctxStfl, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: dialogWidth,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      'Pilih Tipe Kartu',
                      style: CustomTextStyle.titleAlertDialog(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 8),
                    _buildGridSelector(
                      items: cardTypeList,
                      selectedItem: chooseCardType,
                      crossAxisCount: crossAxisCount,
                      onTap: (val) => setState(() => chooseCardType = val),
                    ),
                    const SizedBox(height: 20),
                    _buildActionButtons(ctxDialog, () => chooseCardType),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- PRIVATE HELPERS ---

  static Widget _buildGridSelector({
    required List<String> items,
    required String? selectedItem,
    required Function(String) onTap,
    int crossAxisCount = 2,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: crossAxisCount >= 3 ? 3.2 : 2.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final String label = items[index];
        final bool isSelected = label == selectedItem;

        return InkWell(
          onTap: () => onTap(label),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? CustomColorStyle.appBarBackground() : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? CustomColorStyle.appBarBackground()
                    : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: CustomColorStyle.appBarBackground().withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: AutoSizeText(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              minFontSize: 10,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
                letterSpacing: isSelected ? 0.3 : 0,
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildActionButtons(
      BuildContext context, ValueGetter<String?> getValue) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: CustomButtonStyle.cancelSoft(),
            onPressed: () {
              if (context.mounted && Navigator.canPop(context)) {
                Navigator.pop(context, null);
              }
            },
            child: AutoSizeText(
              'Batal',
              style: CustomTextStyle.whiteSize(15),
              maxLines: 1,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: CustomButtonStyle.confirm(),
            onPressed: () {
              if (context.mounted && Navigator.canPop(context)) {
                Navigator.pop(context, getValue());
              }
            },
            child: AutoSizeText(
              'Pilih',
              style: CustomTextStyle.whiteSize(15),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildLoadingState() {
    return SizedBox(
      height: 140,
      child: Center(
        child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground()),
      ),
    );
  }

  static Widget _buildErrorState(String message) {
    return SizedBox(
      height: 140,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 36),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
