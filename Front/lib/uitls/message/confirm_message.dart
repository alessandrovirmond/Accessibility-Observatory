import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:accessibility_audit/uitls/message/mouse_hovered.dart';
import 'package:flutter/material.dart';


class MessageConfirm extends StatelessWidget {
  final String message;
  final Function yes;
  final Function no;
  final String title;
  final String text;
  final Color color;

  const MessageConfirm(
      {super.key,
      required this.message,
      required this.yes,
      required this.no,
      required this.title,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final double wd = MediaQuery.of(context).size.width;
    final double hg = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: wd,
        height: hg,
        color: Colors.black.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 420,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: color,
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
              width: 420,
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
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: MyStyles.subtitleGrid,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     
                      GestureDetector(
                        onTap: () {
                          no();
                        },
                        child: OnHovered(
                          type: 'selecter',
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: MyStyles.card,
                            child: Text(
                              "Cancelar",
                              style: MyStyles.subBoldBlack,
                            ),
                          ),
                        ),
                      ),
                       GestureDetector(
                        onTap: () {
                          
                          yes();
                        },
                        child: OnHovered(
                          type: 'selecter',
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(1.0, 0.5),
                                    blurRadius: 6.0),
                              ],
                            ),
                            child: Text(
                              text,
                              style: MyStyles.subBoldwhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
