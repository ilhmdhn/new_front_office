import 'package:flutter_bloc/flutter_bloc.dart';

class NumberCubit extends Cubit<int>{
  NumberCubit(): super(0);

  void setValue(int value)async{
    emit(value);
  }
}