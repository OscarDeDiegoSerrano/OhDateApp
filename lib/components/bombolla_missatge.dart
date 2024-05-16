import 'package:flutter/material.dart';

class BombollaMissatge extends StatelessWidget {
  final Color colorBombolla ;
  final String missatge;
  const BombollaMissatge({
    super.key,
    required this.missatge, 
    required this.colorBombolla,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        color: colorBombolla,
        borderRadius: BorderRadius.circular(15),
      ) ,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Text(missatge),
    );
  }
}