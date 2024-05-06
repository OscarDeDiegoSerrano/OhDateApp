import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:ohdate_app/auth/servicio_autentificacion.dart';
import 'package:ohdate_app/paginas/inicio.dart';
import 'package:ohdate_app/paginas/login.dart';
import 'package:ohdate_app/servicios/filePicker.dart';

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

  String? _selectedGender;
  File? _selectedImage; // Guarda la imagen seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
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
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            },
                            items: <String>['Masculino', 'Femenino']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Género',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              // Seleccionar imagen de perfil
                              FilePickerService filePickerService = FilePickerService();
                              Uint8List? imageBytes = await filePickerService.pickImageBytes();
                              if (imageBytes != null) {
                                // Crear un archivo temporal
                                final tempFile = File('profile_image.jpg');

                                // Escribir los bytes en el archivo temporal
                                await tempFile.writeAsBytes(imageBytes);

                                setState(() {
                                  _selectedImage = tempFile;
                                });
                              }
                            },
                            child: const Text('Seleccionar imagen de perfil'),
                          ),


                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedGender != null && _selectedImage != null) {
                                  try {
                                    // Subir imagen de perfil a Firebase Storage
                                    String imageName = emailController.text.replaceAll('@', '_').replaceAll('.', '_') + '.jpg'; // Nombre de la imagen basado en el correo electrónico
                                    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('imagenes/$imageName'); // Ruta a la carpeta "imagenes"

                                    // Convierte el archivo de imagen en bytes
                                    Uint8List imageBytes = Uint8List.fromList(await _selectedImage!.readAsBytes());

                                    // Sube los bytes de la imagen a Firebase Storage
                                    await ref.putData(imageBytes);

                                    // Obtiene la URL de descarga de la imagen
                                    String imageUrl = await ref.getDownloadURL();

                                    // Registrar usuario en Firebase Authentication y Firestore
                                    String? result = await ServicioAutenticacion().registrarUsuario(
                                      emailController.text,
                                      passwordController.text,
                                      nombreController.text,
                                      apellidoController.text,
                                      telefonoController.text,
                                      _selectedGender!,
                                      imageUrl, // Pasando la URL de la imagen como cadena de texto
                                    );

                                    if (result == null) {
                                      // Registro exitoso
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaginaInicio()));
                                    } else {
                                      // Manejar el error si ocurrió durante el registro
                                      // Puedes mostrar un mensaje de error al usuario
                                      print('Error durante el registro: $result');
                                    }
                                  } catch (e) {
                                    print('Error al registrar usuario: $e');
                                  }
                                } else {
                                  // El usuario no seleccionó género o imagen
                                  // Puedes mostrar un mensaje para que seleccione ambos
                                  print('Por favor seleccione género e imagen de perfil.');
                                }
                              }
                            },
                            child: const Text('Registrarse'),
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