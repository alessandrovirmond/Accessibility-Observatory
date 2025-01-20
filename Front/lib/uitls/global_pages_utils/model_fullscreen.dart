import 'package:flutter/material.dart';


class ModelFull extends StatelessWidget {
  final Widget child;
  const ModelFull({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFfafafa),
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        elevation: 0,
        title: Image.asset("asset/horizontal.png", scale:8,),
      ),
      body: child,
    );
  }
}
