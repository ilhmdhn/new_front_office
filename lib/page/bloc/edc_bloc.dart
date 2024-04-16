import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/data/request/api_request.dart';

class EdcCubit extends Cubit<EdcResponse>{
  EdcCubit(): super(EdcResponse());

  void getEdc()async{
    final response = await ApiRequest().getEdc();
    emit(response);
  }
}