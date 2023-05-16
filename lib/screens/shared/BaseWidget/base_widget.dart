import 'package:flutter/cupertino.dart';
import 'package:app_personas/screens/shared/top_container/top_container.dart';
import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {
  final Widget? child;
  const BaseWidget({super.key,  this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: child!),
          TopContainer(),
        ],
      ),
    );
  }
}