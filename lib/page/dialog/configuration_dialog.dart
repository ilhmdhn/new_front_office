import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';

class ConfigurationDialog{

  void setUrl(ctx)async{
    
    showDialog(
      context: ctx, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Center(
            child: Text('Konfigurasi Server', style: CustomTextStyle.titleAlertDialog(),),
          ),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded( flex: 1,child: Text('Ip Server', style: CustomTextStyle.blackStandard(),)),
                    const SizedBox(width: 16,),
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 12,
                        child: TextField(
                          decoration: CustomTextfieldStyle.characterNormal(),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(flex: 1,child: Text('PORT', style: CustomTextStyle.blackStandard())),
                    const SizedBox(width: 16,),
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 12,
                        child: TextField(
                          decoration: CustomTextfieldStyle.characterNormal(),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      return;
                    },
                    style: CustomButtonStyle.cancel(),
                    child: const Text('CANCEL')),
                const SizedBox(width: 20,),
                    ElevatedButton(onPressed: (){
                      return;
                    }, 
                    style: CustomButtonStyle.confirm(),
                    child: const Text('SIMPAN'))
                  ],)
              ],
            ),
          ),
        );
      });
  }
}