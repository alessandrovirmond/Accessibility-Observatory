import 'package:accessibility_audit/uitls/global_styles/my_icons.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';
import '../../controller/dashboard_controller.dart';





class FloatSelecterGrid extends StatefulWidget {
  const FloatSelecterGrid({super.key, required this.controller});
  final DashboardController controller;

  @override
  State<FloatSelecterGrid> createState() => _FloatSelecterGridState();
}

class _FloatSelecterGridState extends State<FloatSelecterGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:const EdgeInsets.only(left: 12, right: 12,top: 8,bottom: 8),
      child: ListView.builder(
        itemCount: widget.controller.select.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {  

          bool select = widget.controller.selecter == index;
    
          return GestureDetector(
            onTap: ()=> setState(()=>widget.controller.selecterGraph = index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
              child: Container(
                width: 145,
                decoration: select ? MyStyles.cardRed : MyStyles.card,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(MyIcons.dashboard, color: select ? Colors.white: Colors.black, size: 14,),
                    Text(widget.controller.select[index].title, style: TextStyle(color: select ? Colors.white: Colors.black,),),
         
                
                ]),

              ),
            ),
          );
        },),
    ) ;
  }
}