import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/list.dart';

class PaymentListDialog {

  // --- 1. E-MONEY LIST ---
  static Future<String?> eMoneyList(BuildContext ctx, String? choosed) {
    String? tempSelected = choosed;

    return showDialog<String?>(
      barrierDismissible: false,
      context: ctx,
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
                      'Pilih E-Money',
                      style: CustomTextStyle.titleAlertDialog(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 8),
                    _buildGridSelector(
                      items: eMoneyValueList,
                      selectedItem: tempSelected,
                      crossAxisCount: crossAxisCount,
                      onTap: (val) => setState(() => tempSelected = val),
                    ),
                    const SizedBox(height: 20),
                    _buildActionButtons(ctxDialog, () => tempSelected),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 2. PIUTANG LIST ---
  static Future<String?> piutangList(BuildContext ctx, String? choosed) {
    String? tempSelected = choosed;

    return showDialog<String?>(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext ctxDialog) {
        final double dialogWidth = ctxDialog.isDesktop && ctxDialog.isLandscape
            ? ctxDialog.wp(40)
            : ctxDialog.isDesktop
                ? ctxDialog.wp(50)
                : ctxDialog.isLandscape
                    ? ctxDialog.wp(65)
                    : ctxDialog.wp(88);

        final int crossAxisCount = ctxDialog.isDesktop || ctxDialog.isLandscape ? 2 : 1;

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
                      'Pilih Piutang',
                      style: CustomTextStyle.titleAlertDialog(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 8),
                    _buildGridSelector(
                      items: piutangValueList,
                      selectedItem: tempSelected,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: crossAxisCount == 1 ? 5.0 : 3.0,
                      onTap: (val) => setState(() => tempSelected = val),
                    ),
                    const SizedBox(height: 20),
                    _buildActionButtons(ctxDialog, () => tempSelected),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 3. SELECT EDC ---
  static Future<EdcDataModel?> selectEdc(BuildContext ctx) {
    return showDialog<EdcDataModel?>(
      context: ctx,
      builder: (BuildContext ctxDialog) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: ctxDialog.isDesktop ? ctxDialog.wp(40) : ctxDialog.wp(88),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  'Pilih EDC',
                  style: CustomTextStyle.titleAlertDialog(),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      'Belum ada data EDC',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: CustomButtonStyle.cancelSoft(),
                    onPressed: () {
                      if (ctxDialog.mounted && Navigator.canPop(ctxDialog)) {
                        Navigator.pop(ctxDialog, null);
                      }
                    },
                    child: AutoSizeText(
                      'Tutup',
                      style: CustomTextStyle.whiteSize(15),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    double childAspectRatio = 2.8,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
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
            padding: const EdgeInsets.symmetric(horizontal: 6),
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
                        color: CustomColorStyle.appBarBackground().withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: AutoSizeText(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              minFontSize: 9,
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
}
