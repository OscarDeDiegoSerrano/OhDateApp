import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ohdate_app/auth/servicio_autentificacion.dart';

class ModificarDatosUsuario extends StatefulWidget {
  @override
  _ModificarDatosUsuarioState createState() => _ModificarDatosUsuarioState();
}

class _ModificarDatosUsuarioState extends State
{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Obtener datos del usuario actual y establecerlos en los controladores de texto
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    try {
      // Obtener el ID del usuario actual
      String idUsuarioActual = ServicioAutenticacion().getUsuariActual()!.uid;

      // Obtener los datos del usuario actual desde Firestore
      DocumentSnapshot usuarioSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(idUsuarioActual)
          .get();

      // Extraer los datos del usuario
      Map<String, dynamic> datosUsuario = usuarioSnapshot.data() as Map<String, dynamic>;

      // Establecer los valores en los controladores de texto
      _nombreController.text = datosUsuario['nombre'] ?? '';
      _apellidoController.text = datosUsuario['apellido'] ?? '';
      _telefonoController.text = datosUsuario['telefono'] ?? '';
      _emailController.text = datosUsuario['email'] ?? '';
    } catch (error) {
      print('Error al cargar los datos del usuario: $error');
      // Manejar el error según sea necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retornar a la página anterior
          },
        ),
        title: Text('Modificar Datos'), // Título de la AppBar
      ),
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
                          'Modificar datos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                controller: _nombreController,
                                decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  filled: true,
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
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese su apellido';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _telefonoController,
                                decoration: InputDecoration(
                                  labelText: 'Teléfono',
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese su teléfono';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Correo electrónico',
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese su correo electrónico';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Obtener los valores de los campos de texto
                              String nombre = _nombreController.text;
                              String apellido = _apellidoController.text;
                              String telefono = _telefonoController.text;
                              String email = _emailController.text;

                              String idUsuarioActual = ServicioAutenticacion().getUsuariActual()!.uid;

                              // Modificar los datos en la base de datos
                              FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(idUsuarioActual)
                                  .update({
                                'nombre': nombre,
                                'apellido': apellido,
                                'telefono': telefono,
                                'email': email,
                              }).then((_) {
                                // Si la actualización es correcta, muestra un mensaje
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Datos actualizados correctamente'),
                                  duration: Duration(seconds: 2),
                                ));
                              }).catchError((error) {
                                // Si hay un error, muestra mensaje de error
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Error al actualizar los datos: $error'),
                                  duration: Duration(seconds: 2),
                                ));
                              });
                            }
                          },
                          child: Text('Aplicar'),
                        ),
                        SizedBox(height: 10),
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


void main() {
  runApp(ModificarDatosUsuario());
}
