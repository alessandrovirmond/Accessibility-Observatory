import 'package:accessibility_audit/home/home_page/graph_home/graph_home.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
    final Function() onUpdate;
  const HomePage({super.key,  required this.onUpdate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: GraphHome(onUpdate: widget.onUpdate)),
        
      ],
    );
  }
}
