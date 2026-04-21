import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/fnb_model.dart';

final inputOrderProvider = StateNotifierProvider<SelectedFoodProvider, List<SendOrderModel>?>((ref) {
  return SelectedFoodProvider();
});

class SelectedFoodProvider extends StateNotifier<List<SendOrderModel>> {
  SelectedFoodProvider() : super([]);

  void addedFood(SendOrderModel order) {
    state = [...state, order];
  }

  void deleteAt(String itemCode){
    state = state.where((item) => item.invCode != itemCode).toList();
  }

  void updateQty(String itemCode, int qty){
    state = state.map((item) {
      if (item.invCode == itemCode) {
        return item.copyWith(qty: qty);
      }
      return item;
    }).toList();
  }

  void addNote(String itemCode, String note){
    state = state.map((item) {
      if (item.invCode == itemCode) {
        return item.copyWith(note: note);
      }
      return item;
    }).toList();
  }

  void clear() {
    state = [];
  }
}