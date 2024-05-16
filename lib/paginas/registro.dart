import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ohdate_app/servicios/servicio_autentificacion.dart';
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

  ServicioAutenticacion serveiAuth = ServicioAutenticacion();

  String? _selectedGender;
  //File? _selectedImage; // Guarda la imagen seleccionada

  File? _imatgeSeleccionadaApp;
  Uint8List? _imatgeSeleccionadaWeb;

  Future<void> _triaImatge() async {

    final ImagePicker picker = ImagePicker();
    XFile? imatge = await picker.pickImage(source: ImageSource.gallery);

    // Si trien i trobem la imatge.
    if (imatge != null) {

      // Si l'App s'executa en un dispositiu mòbil.
      if (!kIsWeb) {

        File arxiuSeleccionat = File(imatge.path);
        
        setState(() {
          _imatgeSeleccionadaApp = arxiuSeleccionat;
        });
        
      }

      // Si l'App s'executa en un navegador web.
      if (kIsWeb) {
        Uint8List arxiuEnBytes = await imatge.readAsBytes();

        setState(() {
          _imatgeSeleccionadaWeb = arxiuEnBytes;
        });
      }
    }

  }

  Future<bool> pujarImatgePerUsuari() async {
  // Obtén el usuario actual de manera segura
  final usuarioActual = serveiAuth.getUsuariActual();
  if (usuarioActual == null) {
    // Manejar el caso en que el usuario actual es nulo
    print("No encuentra usaurio");
    return false;
  }

  String idUsuari = usuarioActual.uid;
  Reference ref = FirebaseStorage.instance.ref().child("$idUsuari/avatar/$idUsuari");

  // Agafem la imatge de la variable que la tingui (la de web o la de App).
  if (_imatgeSeleccionadaApp != null) {
    try {
      await ref.putFile(_imatgeSeleccionadaApp!);
      return true;
    } catch (e) {
      // Manejar cualquier error que ocurra durante la carga del archivo
      print(e.toString());
      return false;
    }
  }

  if (_imatgeSeleccionadaWeb != null) {
    try {
      await ref.putData(_imatgeSeleccionadaWeb!);
      return true;
    } catch (e) {
      // Manejar cualquier error que ocurra durante la carga de datos
      print(e.toString());
      return false;
    }
  }

  // Manejar el caso en que ambas imágenes sean nulas
  return false;
}




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
                            onPressed: _triaImatge,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              primary: Color.fromARGB(255, 236, 144, 229),
                            ),
                            child: const Text("Tria imatge"),
                          ),

                          Container(
                            height: 100,
                            width: 100,
                            child: _imatgeSeleccionadaWeb == null && _imatgeSeleccionadaApp == null ? 
                              Container() : 
                              kIsWeb ? 
                              Image.memory(_imatgeSeleccionadaWeb!, fit: BoxFit.fill,) :
                              Image.file(_imatgeSeleccionadaApp!, fit: BoxFit.fill,),
                          ),


                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedGender != null) {
                                  try {
                                    if (true) {
                                      // La imagen se subió correctamente, ahora registrar usuario en Firebase Authentication y Firestore
                                      String? result = await serveiAuth.registrarUsuario(
                                        emailController.text,
                                        passwordController.text,
                                        nombreController.text,
                                        apellidoController.text,
                                        telefonoController.text,
                                        _selectedGender!
                                      );

                                      if (result == null) {
                                        // Registro exitoso
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaginaInicio()));
                                      } else {
                                        // Manejar el error si ocurrió durante el registro
                                        // Puedes mostrar un mensaje de error al usuario
                                        print('Error durante el registro: $result');
                                      }
                                    }

                                    bool imatgePujada = await pujarImatgePerUsuari();
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