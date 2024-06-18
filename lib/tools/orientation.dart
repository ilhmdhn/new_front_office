import 'package:flutter/cupertino.dart';

bool isVertical(BuildContext ctx){
  final orientationState = MediaQuery.of(ctx).orientation; 
  if(orientationState == Orientation.portrait){
    return true;
  }else{
    return false;
  }
}