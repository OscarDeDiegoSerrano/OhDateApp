import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/conversaciones.dart';
import 'package:ohdate_app/paginas/inicio.dart';

class PreferenciaBusqueda extends StatefulWidget {
  @override
  _PreferenciaBusquedaState createState() => _PreferenciaBusquedaState();
}

class _PreferenciaBusquedaState extends State<PreferenciaBusqueda> {
  final _formKey = GlobalKey<FormState>();

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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Preferencias de Búsqueda',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
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
                                  // Aquí puedes realizar la acción de guardar las preferencias de búsqueda
                                  // por ejemplo, podrías guardar los valores en la base de datos
                                  // o utilizarlos para filtrar resultados
                                  // Aquí solo muestro un mensaje de éxito y retorno a la página de inicio
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
