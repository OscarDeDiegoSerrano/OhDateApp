import 'package:flutter/material.dart';

class CambiarPassword extends StatelessWidget {
  const CambiarPassword({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink[100],
        scaffoldBackgroundColor: Colors.pink[100],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cambiar Contraseña'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: Image.asset(
                    'lib/imatges/LogoOhDate.png', // Ruta de la imagen.
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Cambiar Contraseña',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CambiarPasswordForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CambiarPasswordForm extends StatefulWidget {
  @override
  _CambiarPasswordFormState createState() => _CambiarPasswordFormState();
}

class _CambiarPasswordFormState extends State<CambiarPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Nueva Contraseña',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su nueva contraseña';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirmar Contraseña',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor confirme su nueva contraseña';
              } else if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('¡Contraseña cambiada con éxito!')),
                );
                // Aquí puedes agregar la lógica para cambiar la contraseña
              }
            },
            child: Text('Cambiar Contraseña'),
          ),
        ],
      ),
    );
  }
}
