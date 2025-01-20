import 'package:flutter/cupertino.dart';
import 'time_pop.dart';
import 'confirm_message.dart';

class MakerMessage{

  static confirm (context, String title, String message, Color color, String textButton,  Function yes,) {
 
     Navigator.of(context,rootNavigator: true).push(CupertinoDialogRoute(
        context: context,
        builder: (context)=>MessageConfirm(
            color: color,
            title:title,
            message: message,
            yes:(){
              yes();
              Navigator.of(context).pop();
            },
            no:(){
            Navigator.of(context).pop();
            }, 
            text: textButton,
            
        )
    ));
  }

  static error( String title,  Widget message, {required BuildContext context}){
    
    Navigator.of(context ,rootNavigator: true).push(CupertinoDialogRoute(
        context: context,
        builder: (context)=>TimePop(title: title, message: message) ));
  }

}