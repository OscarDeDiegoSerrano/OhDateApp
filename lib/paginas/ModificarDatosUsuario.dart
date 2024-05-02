import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

// Define el callback onImageSelected
typedef OnImageSelected = void Function(Uint8List? image);

class FilePickerWidget extends StatelessWidget {
  final OnImageSelected onImageSelected;

  const FilePickerWidget({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _seleccionarImagen(),
      child: const Text('Seleccionar imagen de perfil'),
    );
  }

  void _seleccionarImagen() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        if (kIsWeb) {
          onImageSelected(result.files.single.bytes);
        } else {
          onImageSelected(result.files.single.bytes!);
        }
      } else {
        print('El usuario canceló la selección de imagen.');
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }
}

class ModificarDatosUsuario extends StatefulWidget {
  @override
  _ModificarDatosUsuarioState createState() => _ModificarDatosUsuarioState();
}

class _ModificarDatosUsuarioState extends State<ModificarDatosUsuario> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _selectedSexo = TextEditingController();
  Uint8List? _rutaImagen;

  @override
  void initState() {
    super.initState();
    // Llama a la función para cargar los datos del usuario
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    // Lógica para cargar los datos del usuario desde Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Modificar Datos'),
      ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Modificar datos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              // Llama al widget filePicker para seleccionar la imagen de perfil
                              FilePickerWidget(
                                onImageSelected: (Uint8List? image) {
                                  setState(() {
                                    _rutaImagen = image;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _nombreController,
                                decoration: const InputDecoration(
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
                                decoration: const InputDecoration(
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
                                decoration: const InputDecoration(
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
                                decoration: const InputDecoration(
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
                              TextFormField(
                                controller: _selectedSexo,
                                decoration: const InputDecoration(
                                  labelText: 'Sexo',
                                  filled: true,
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Lógica para actualizar los datos en Firestore
                                  }
                                },
                                child: const Text('Aplicar'),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
