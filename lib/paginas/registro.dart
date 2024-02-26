import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(Registrarse());
}

class Registrarse extends StatelessWidget {
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
                    image: AssetImage("lib/imatges/fondo.jpg"), // Ruta de la imagen de fondo
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Contenido central
            Center(
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
                            '¡Únete a nosotros!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          RegisterForm(),
                          SizedBox(height: 10), // Espacio entre el formulario y los botones
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  //Ayuda
                                },
                                child: Text('¿Ya tienes una cuenta?'),
                              ),
                            ],
                          ),
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

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _edadController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: 'Nombre',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su nombre';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _apellidoController,
            decoration: InputDecoration(
              labelText: 'Apellido',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su apellido';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo electrónico';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _edadController,
            decoration: InputDecoration(
              labelText: 'Fecha de nacimiento', // Cambiar el texto del label si es necesario
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su fecha de nacimiento';
              }
              return null;
            },
            onTap: () async {
              // Lógica para mostrar un selector de fecha
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                  _edadController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                });
              }
            },
          ),
          TextFormField(
            controller: _telefonoController,
            decoration: InputDecoration(
              labelText: 'Teléfono',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su teléfono';
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('¡Registro exitoso!')),
                );
              }
            },
            child: Text('Registrarse'),
          ),
        ],
      ),
    );
  }
}
