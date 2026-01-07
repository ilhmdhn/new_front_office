import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/tools/preferences.dart';

// Provider untuk Show Retur State
final showReturProvider = StateNotifierProvider<ShowReturNotifier, bool>((ref) {
  return ShowReturNotifier();
});

class ShowReturNotifier extends StateNotifier<bool> {
  ShowReturNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getShowReturState();
  }

  void _loadState() {
    state = PreferencesData.getShowReturState();
  }

  void setShowRetur(bool value) {
    PreferencesData.setShowRetur(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}

// Provider untuk Show Total Item Promo
final showTotalItemPromoProvider = StateNotifierProvider<ShowTotalItemPromoNotifier, bool>((ref) {
  return ShowTotalItemPromoNotifier();
});

class ShowTotalItemPromoNotifier extends StateNotifier<bool> {
  ShowTotalItemPromoNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getShowTotalItemPromo();
  }

  void _loadState() {
    state = PreferencesData.getShowTotalItemPromo();
  }

  void setShowTotalItemPromo(bool value) {
    PreferencesData.setShowTotalItemPromo(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}

// Provider untuk Show Promo Below Item
final showPromoBelowItemProvider = StateNotifierProvider<ShowPromoBelowItemNotifier, bool>((ref) {
  return ShowPromoBelowItemNotifier();
});

class ShowPromoBelowItemNotifier extends StateNotifier<bool> {
  ShowPromoBelowItemNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getShowPromoBelowItem();
  }

  void _loadState() {
    state = PreferencesData.getShowPromoBelowItem();
  }

  void setShowPromoBelowItem(bool value) {
    PreferencesData.setShowPromoBelowItem(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}
