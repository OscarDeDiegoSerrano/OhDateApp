import 'package:flutter/material.dart';

class RestablecerContrasena extends StatelessWidget {
  const RestablecerContrasena({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink[100],
        scaffoldBackgroundColor: Colors.pink[100],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Restablecer Contraseña'),
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
                        'Restablecer Contraseña',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      RestablecerContrasenaForm(),
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

class RestablecerContrasenaForm extends StatefulWidget {
  @override
  _RestablecerContrasenaFormState createState() =>
      _RestablecerContrasenaFormState();
}

class _RestablecerContrasenaFormState extends State<RestablecerContrasenaForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Correo Electrónico',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo electrónico';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Aquí deberías implementar la lógica para enviar el correo con el código para restablecer la contraseña
                enviarCorreo(_emailController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Se ha enviado un correo electrónico con instrucciones para restablecer la contraseña.'),
                  ),
                );
              }
            },
            child: Text('Enviar Código'),
          ),
        ],
      ),
    );
  }

  // Función para enviar el correo con el código para restablecer la contraseña
  void enviarCorreo(String email) {
    // Aquí deberías implementar la lógica para enviar el correo electrónico
    // Puedes utilizar servicios como Firebase Authentication, SendGrid, etc.
    // Por simplicidad, aquí solo se muestra un ejemplo ficticio.
    print('Enviando correo a $email con el código para restablecer la contraseña...');
  }
}
