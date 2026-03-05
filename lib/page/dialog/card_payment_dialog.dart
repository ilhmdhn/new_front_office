import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/page/bloc/edc_bloc.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/list.dart';

class CardPaymentDialog {
  
  // --- 1. FUNCTION: EDC MACHINE ---
  Future<String?> edcMachine(BuildContext ctx) {
    String? chooseEdc;
    EdcCubit edcResponse = EdcCubit();
    edcResponse.getEdc();

    return showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColorStyle.white(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Center(
            child: Text('Pilih Mesin Edc', style: CustomTextStyle.titleAlertDialog()),
          ),
          content: BlocBuilder<EdcCubit, EdcResponse>(
            bloc: edcResponse,
            builder: (BuildContext ctxBloc, EdcResponse edc) {
              if (edc.isLoading == true) {
                return _buildLoadingState(ctx);
              }
              if (edc.state != true) {
                return _buildErrorState(ctx, edc.message.toString());
              }

              List<String> edcList = edc.data.map((e) => e.edcName.toString()).toList();

              return StatefulBuilder(
                builder: (ctxStfl, setState) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildGridSelector(
                          items: edcList,
                          selectedItem: chooseEdc,
                          onTap: (val) => setState(() => chooseEdc = val),
                        ),
                        const SizedBox(height: 24),
                        _buildActionButtons(context, () => chooseEdc),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  // --- 2. FUNCTION: CARD TYPE ---
  Future<String?> cardType(BuildContext ctx) {
    String? chooseCardType;
    
    return showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctxStfl, setState) {
            return AlertDialog(
              backgroundColor: CustomColorStyle.white(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Center(
                child: Text('Pilih Tipe Kartu', style: CustomTextStyle.titleAlertDialog()),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGridSelector(
                      items: cardTypeList, // Pastikan cardTypeList terdefinisi secara global/di class
                      selectedItem: chooseCardType,
                      onTap: (val) => setState(() => chooseCardType = val),
                    ),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, () => chooseCardType),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- PRIVATE HELPER WIDGETS (Untuk tampilan Minimalis) ---

  Widget _buildGridSelector({
    required List<String> items,
    required String? selectedItem,
    required Function(String) onTap,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8, // Mengatur kerampingan tombol (semakin besar semakin tipis)
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final String label = items[index];
        final bool isSelected = label == selectedItem;

        return InkWell(
          onTap: () => onTap(label),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? CustomColorStyle.appBarBackground() : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CustomColorStyle.appBarBackground(),
                width: 1,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, ValueGetter<String?> getValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            style: CustomButtonStyle.cancel(),
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: CustomTextStyle.whiteSize(16)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: CustomButtonStyle.confirm(),
            onPressed: () => Navigator.pop(context, getValue()),
            child: Text('Ganti', style: CustomTextStyle.whiteSize(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext ctx) {
    return SizedBox(
      height: 150,
      child: Center(
        child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground()),
      ),
    );
  }

  Widget _buildErrorState(BuildContext ctx, String message) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}