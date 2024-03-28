import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/request/cloud_request.dart';

class ApprovalCubit extends Cubit<BaseResponse>{
  ApprovalCubit(): super(BaseResponse());

  void sendApproval(String id, String rcp, String notes)async{
    final response = await CloudRequest.apporvalRequest(id, rcp, notes);
    emit(response);
  }
}