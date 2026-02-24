import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/print_job.dart';

final printJobProvider = StateNotifierProvider<PrintFailedNotifier, List<PrintJob>>((ref) {
  return PrintFailedNotifier();
});

class PrintFailedNotifier extends StateNotifier<List<PrintJob>> {
  PrintFailedNotifier() : super([]) {
    _loadState();
  }

  void _loadState() {
    state = [];
  }

  void addJob(PrintJob value) {
    state = [...state, value];
  }

  void removeJob(PrintJob value) {
    state = state.where((e) => e != value).toList();
  }

  void clear() {
    state = [];
  }
}