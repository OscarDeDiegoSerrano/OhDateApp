import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/inicio.dart';

class PreferenciaBusqueda extends StatefulWidget {
  @override
  _PreferenciaBusquedaState createState() => _PreferenciaBusquedaState();
}

class _PreferenciaBusquedaState extends State<PreferenciaBusqueda> {
  final _formKey = GlobalKey<FormState>();

  String? generoSeleccionado;
  String distanciaSeleccionada = '1 km';
  RangeValues rangoEdadSeleccionado = const RangeValues(18, 60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias de Búsqueda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              DropdownButtonFormField<String>(
                value: distanciaSeleccionada,
                onChanged: (newValue) {
                  setState(() {
                    distanciaSeleccionada = newValue!;
                  });
                },
                items: <String>['1 km', '5 km', '10 km', '20 km']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Distancia (hasta)',
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
    );
  }
}
