import 'package:flutter/material.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/tools/toast.dart';

class ErrorHandling{
  void apiError(ctx, message){
    if(message == 'invalid token'){
      Navigator.pushNamedAndRemoveUntil(ctx, LoginPage.nameRoute, (route) => false);
      showToastError('Password telah diganti/ Login di perangkat lain');
    }
  }
}