import 'package:flutter/material.dart';
import 'package:ohdate_app/auth/servicio_autentificacion.dart';
import 'package:ohdate_app/paginas/inicio.dart';
import 'package:ohdate_app/paginas/login.dart';


class Registrarse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // Contenido central
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
                          '¡Únete a nosotros!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        RegisterForm(),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => IniciarSesion()));
                          },
                          child: Text('¿Ya tienes una cuenta?'),
                        ),
                        ElevatedButton(
                          onPressed: () async {

                            print(RegisterForm().emailController.text);

                            ServicioAutenticacion().registrarUsuario(
                              RegisterForm().emailController.text,
                              RegisterForm().passwordController.text,
                              RegisterForm().nombreController.text,
                              RegisterForm().apellidoController.text,
                              RegisterForm().telefonoController.text,
                            );

                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaginaInicio()));
                          },
                          child: Text('Registrarse'),
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
    );
  }
}

class RegisterForm extends StatefulWidget {

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  
  /*String? selectedSex;*/

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: widget.nombreController,
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
            controller: widget.apellidoController,
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
            controller: widget.emailController,
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
            controller: widget.telefonoController,
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
            controller: widget.passwordController,
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
          /*DropdownButtonFormField<String>(
            value: selectedSex,
            onChanged: (newValue) {
              
              setState(() {
                selectedSex = newValue;
              });
            },
            decoration: InputDecoration(
              labelText: 'Sexo',
            ),
            items: <String>['Hombre', 'Mujer', 'No quiero especificar']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor seleccione su orientación sexual';
              }
              return null;
            },
          ),*/
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
