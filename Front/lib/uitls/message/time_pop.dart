import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:accessibility_audit/uitls/message/mouse_hovered.dart';
import 'package:flutter/material.dart';

class TimePop extends StatelessWidget {
  final String title;
  final Widget message;

  const TimePop({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {

    final double wd = MediaQuery.of(context).size.width;
    final double hg = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: Container(
          width: wd,
          height: hg,
          color: Colors.black.withOpacity(0.2),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 400,
              height: 60,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(color: Colors.blueAccent),
                    BoxShadow(color: Colors.blue)
                  ]),
              alignment: Alignment.center,
              child: Text(
                title,
                style: MyStyles.subBoldwhite,
              ),
            ),
            Container(
              width: 400,
              height: 200,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1.0, 0.5),
                      blurRadius: 6.0),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  message,
                  GestureDetector(
                    onTap:(){Navigator.pop(context);},
                    child: OnHovered(
                      type: 'selecter',
                      child: Container(
                        width: 90,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        decoration: MyStyles.card,
                        child: Text("OK", style: MyStyles.subBoldBlack,),
                      ),
                    ),
                  )
                ],
              ),
            ),


          ])
      ),
    );
  }
}
