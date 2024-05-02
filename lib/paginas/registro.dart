import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ohdate_app/auth/servicio_autentificacion.dart';
import 'package:ohdate_app/paginas/inicio.dart';
import 'package:ohdate_app/paginas/login.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _selectedSexo;
  String? _imageUrl; // Nuevo estado para mantener la URL de la imagen seleccionada

  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      // Llama a _uploadImage con el archivo seleccionado
      _uploadImage(File(pickedFile.path));
    });
  }
}

Future<void> _uploadImage(File imageFile) async {
  try {
    final Reference storageRef = FirebaseStorage.instance.ref().child('perfil').child('${DateTime.now()}.jpg');
    final Uint8List imageData = await imageFile.readAsBytes();
    await storageRef.putData(imageData);
    final String url = await storageRef.getDownloadURL();
    setState(() {
      _imageUrl = url; // Actualiza _imageUrl con la nueva URL de la imagen
    });
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir durante la carga de la imagen
    print('Error al cargar la imagen: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
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
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '¡Únete a nosotros!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nombreController,
                            decoration: const InputDecoration(
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
                            controller: apellidoController,
                            decoration: const InputDecoration(
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
                            controller: emailController,
                            decoration: const InputDecoration(
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
                            controller: telefonoController,
                            decoration: const InputDecoration(
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
                            controller: passwordController,
                            decoration: const InputDecoration(
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
                          DropdownButtonFormField<String>(
                            value: _selectedSexo,
                            onChanged: (nuevoValor) {
                              setState(() {
                                _selectedSexo = nuevoValor;
                              });
                            },
                            items: <String>['Hombre', 'Mujer'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Sexo',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione su sexo';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('Seleccionar imagen'),
                          ),
                          if (_imageUrl != null)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 100,
                              width: 100,
                              //child: Image.network(_imageUrl!),
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => IniciarSesion()),
                              );
                            },
                            child: const Text('¿Ya tienes una cuenta?'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                ServicioAutenticacion().registrarUsuario(
                                  emailController.text,
                                  passwordController.text,
                                  nombreController.text,
                                  apellidoController.text,
                                  telefonoController.text,
                                  _selectedSexo!,
                                  _imageUrl!,
                                );
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaginaInicio()));
                              }
                            },
                            child: const Text('Registrarse'),
                          ),
                        ],
                      ),
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
