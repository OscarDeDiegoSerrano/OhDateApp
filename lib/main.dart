import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ohdate_app/firebase_options.dart';
import 'package:ohdate_app/paginas/registro.dart';
import 'package:ohdate_app/paginas/cambiarpassword.dart';
import 'package:ohdate_app/paginas/registro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
      ],
      // Define las rutas
      routes: {
        '/': (context) => RegisterForm(),
        '/cambiarContrasena': (context) => const RestablecerContrasena(),
      },
      initialRoute: '/', // La ruta inicial es Registrarse
    );
  }
}

