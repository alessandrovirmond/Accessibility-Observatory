import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';

class GlobalEmpty extends StatelessWidget {
  const GlobalEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text("Realize a leitura",
                  textAlign: TextAlign.center, style: MyStyles.subBoldBlack),
            ),
          ],
        )
      ],
    );
  }
}
