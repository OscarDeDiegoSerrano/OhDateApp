import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/registro.dart';
import 'package:ohdate_app/paginas/cambiarpassword.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
         GlobalMaterialLocalizations.delegate
       ],
       supportedLocales: [
         Locale('en'),
         Locale('sp'),
       ],
      // Define las rutas
      routes: {
        '/': (context) => Registrarse(),
        '/cambiarContrasena': (context0) => RestablecerContrasena(),
      },
      initialRoute: '/', // La ruta inicial es Registrarse
    );
  }
}

