import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GlobalPageLoadingPercent extends StatelessWidget {
  final Stream<int>? percent;
  const GlobalPageLoadingPercent({super.key, this.percent});

  @override
  Widget build(BuildContext context) {
    if (percent == null) {
      return Container(
        color: PalleteColor.scaffold,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: PalleteColor.red,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      color: PalleteColor.scaffold,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(
                color: PalleteColor.red,
                size: 60,
              ),
            ],
          ),
          const SizedBox(height: 0),
          StreamBuilder<int>(
              stream: percent,
              builder: (context, snapshot) {
                return Center(
                    child: Text("${snapshot.data ?? 0} %",
                        style: MyStyles.titleGridBlack));
              })
        ],
      ),
    );
  }
}
