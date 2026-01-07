import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/riverpod/provider_container.dart';
import 'package:front_office_2/riverpod/server_config_provider.dart';

class ApprovalCountCubit extends Cubit<String>{
  ApprovalCountCubit(): super('');

  void getData()async{
    final outletCode = GlobalProviders.read(outletProvider);
    final response = await CloudRequest.totalApprovalRequest(outletCode);
    emit(response.message??'');
  }
}