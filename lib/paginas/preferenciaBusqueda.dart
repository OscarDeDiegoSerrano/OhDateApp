import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ohdate_app/paginas/conversaciones.dart';
import 'package:ohdate_app/paginas/inicio.dart';

class PreferenciaBusqueda extends StatefulWidget {
  @override
  _PreferenciaBusquedaState createState() => _PreferenciaBusquedaState();
}

class _PreferenciaBusquedaState extends State<PreferenciaBusqueda> {
  final _formKey = GlobalKey<FormState>();
  User? usuarioActual = FirebaseAuth.instance.currentUser;

  String? generoSeleccionado;
  RangeValues rangoEdadSeleccionado = const RangeValues(18, 60);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink[100],
        scaffoldBackgroundColor: Colors.pink[100],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Preferencias de Búsqueda'),
        ),
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
                              'Preferencias de Búsqueda',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: generoSeleccionado,
                              onChanged: (newValue) {
                                setState(() {
                                  generoSeleccionado = newValue!;
                                });
                              },
                              items: <String>['Hombre', 'Mujer']
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rango de Edad',
                                  style: TextStyle(fontSize: 16),
                                ),
                                RangeSlider(
                                  values: rangoEdadSeleccionado,
                                  min: 18,
                                  max: 80,
                                  divisions: 62,
                                  labels: RangeLabels(
                                    '${rangoEdadSeleccionado.start.round()}',
                                    '${rangoEdadSeleccionado.end.round()}',
                                  ),
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      rangoEdadSeleccionado = values;
                                    });
                                  },
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Edad mínima: ${rangoEdadSeleccionado.start.round()}, Edad máxima: ${rangoEdadSeleccionado.end.round()}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Save preferences to the user's profile in Firebase
                                  await FirebaseFirestore.instance
                                      .collection('usuarios')
                                      .doc(usuarioActual!.uid)
                                      .update({
                                    'generoPreferencia': generoSeleccionado,
                                    'edadMinima': rangoEdadSeleccionado.start.round(),
                                    'edadMaxima': rangoEdadSeleccionado.end.round(),
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Preferencias guardadas con éxito')),
                                  );
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaginaInicio()));
                                }
                              },
                              child: const Text('Guardar Preferencias'),
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
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Conversaciones()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaginaInicio()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Acción al presionar el botón de ajustes
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
