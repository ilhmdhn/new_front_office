import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/tools/preferences.dart';

class ApprovalCountCubit extends Cubit<String>{
  ApprovalCountCubit(): super('');

  void getData()async{
    final outletCode = PreferencesData.getOutlet();
    final response = await CloudRequest.totalApprovalRequest(outletCode);
    emit(response.message??'');
  }
}