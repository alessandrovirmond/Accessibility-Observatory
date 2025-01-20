import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatefulWidget {
  final double scale;
  const Loading({super.key, required this.scale});


  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {


    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: PalleteColor.red, size: widget.scale,
      ),
    );
  }
}
