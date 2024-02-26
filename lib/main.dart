import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/registro.dart';
import 'package:ohdate_app/paginas/cambiarpassword.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define las rutas
      routes: {
        '/': (context) => Registrarse(),
        '/cambiarContrasena': (context) => CambiarPassword(),
      },
      initialRoute: '/', // La ruta inicial es Registrarse
    );
  }
}

class Registrarse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cambiarContrasena');
          },
          child: Text('Ir a la página de cambiar contraseña'),
        ),
      ),
    );
  }
}