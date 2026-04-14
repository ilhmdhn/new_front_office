import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/tools/preferences.dart';

final ratingFeatureProvider = StateNotifierProvider<RatingFeatureNotifier, bool>((ref) {
  return RatingFeatureNotifier();
});

class RatingFeatureNotifier extends StateNotifier<bool> {
  RatingFeatureNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getRatingFeature();
  }

  void _loadState() {
    state = PreferencesData.getRatingFeature();
  }

  void setRatingFeature(bool value) {
    PreferencesData.setRatingFeature(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}
