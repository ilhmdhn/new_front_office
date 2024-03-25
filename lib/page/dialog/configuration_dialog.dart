import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/network.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';

class ConfigurationDialog{

  void setUrl(ctx)async{
    TextEditingController tfIp = TextEditingController();
    TextEditingController tfPort = TextEditingController();
    TextEditingController tfOutlet = TextEditingController();
    BaseUrlModel serverUrl = PreferencesData.getConfigUrl();

    if(isNotNullOrEmpty(serverUrl.ip)){
      tfIp.text = serverUrl.ip!;
    }

    if(isNotNullOrEmpty(serverUrl.port)){
      tfPort.text = serverUrl.port!;
    }

    if(isNotNullOrEmpty(serverUrl.outlet)){
      tfOutlet.text = serverUrl.outlet!;
    }

    showDialog(
      context: ctx, 
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState){
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
                      Expanded( flex: 2,child: Text('Ip Server', style: CustomTextStyle.blackStandard(),)),
                      const SizedBox(width: 16,),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: tfIp,
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
                      Expanded(flex: 2,child: Text('PORT', style: CustomTextStyle.blackStandard())),
                      const SizedBox(width: 16,),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: tfPort,
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
                      Expanded(flex: 2,child: Text('OUTLET', style: CustomTextStyle.blackStandard())),
                      const SizedBox(width: 16,),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: tfOutlet,
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
                        Navigator.pop(context);
                      },
                      style: CustomButtonStyle.cancel(),
                      child: const Text('CANCEL')),
                  const SizedBox(width: 20,),
                      ElevatedButton(onPressed: ()async{
                        if(isNotNullOrEmpty(tfIp.text) && isNotNullOrEmpty(tfPort.text) && isNotNullOrEmpty(tfOutlet.text)){
                          await PreferencesData.setUrl(BaseUrlModel(
                            ip: tfIp.text,
                            port: tfPort.text,
                            outlet: tfOutlet.text
                          ));
                          if(context.mounted){
                            Navigator.pop(context);
                          }
                        }else{
                          showToastWarning('Isi semua field');
                        }
                      }, 
                      style: CustomButtonStyle.confirm(),
                      child: const Text('SIMPAN'))
                    ],)
                ],
              ),
            ),
          );
          }
          );
      });
  }
 
}