import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class ConfirmationSignalModel{
  String code;
  ConfirmationSignalModel({required this.code});
}