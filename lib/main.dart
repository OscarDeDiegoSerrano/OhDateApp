import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/registro.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Registrarse(),
    );
  }
}