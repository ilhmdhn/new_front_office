import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class ConfirmationSignalModel{
  String code;
  bool state;
  ConfirmationSignalModel({required this.code, required this.state});
}

class RefreshApprovalCount{}