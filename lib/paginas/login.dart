import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/cambiarpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ohdate_app/paginas/inicio.dart';

class IniciarSesion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink[100],
        scaffoldBackgroundColor: Colors.pink[100],
      ),
      home: Scaffold(
        body: Stack(
          children: [
            // Fondo
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/imatges/fondo.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Image.asset(
                        'lib/imatges/LogoOhDate.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Inicio de sesión',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          LoginForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void hemCridatBoto() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RestablecerContrasena()),
    );
  }

  Future<String?> signIn(String email, String password) async {
    try {
      // Inicio de sesión con Firebase Authentication
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null; // Inicio de sesión exitoso
    } catch (e) {
      if (e is FirebaseAuthException) {
        return e.message; // Devuelve el mensaje de error de Firebase Authentication
      } else {
        return 'Error desconocido'; // Manejar otros posibles errores
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su nombre de usuario';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su contraseña';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String? result = await signIn(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Inicio de sesión exitoso!')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaginaInicio()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $result')),
                  );
                }
              }
            },
            child: Text('Iniciar Sesión'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: hemCridatBoto,
            child: Text("Restablecer contraseña"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20),
              textStyle: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
