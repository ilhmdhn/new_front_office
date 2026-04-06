import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class ConfirmationSignalModel{
  String code;
  bool state;
  String approver;
  ConfirmationSignalModel({required this.code, required this.state, required this.approver});
}

class RefreshApprovalCount{}