import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({
    required this.i,
    required this.j,
    super.key,
  });

  final int i;
  final int j;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    hello();
    widget.i;
    return const Placeholder();
  }

  void hello() {}
}
