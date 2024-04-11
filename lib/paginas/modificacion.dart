import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(
  title: "App",
  home: Modificacion(), // Cambio de UserProfile a Modificacion
  theme: ThemeData(
    primaryColor: Colors.pink[100],
    scaffoldBackgroundColor: Colors.pink[100],
  ),
));

class Modificacion extends StatelessWidget { // Cambio de UserProfile a Modificacion
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
                          'Modificar datos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ModificacionForm(), // Cambio de UserProfileForm a ModificacionForm
                        SizedBox(height: 10), 
                        ElevatedButton(
                          
                          onPressed: () {
                            // Implementar la funcionalidad de aplicar cambios aquí
                            Navigator.pop(context); // Volvemos a la pantalla anterior
                          },
                          child: Text('Aplicar'),
                        ),
                        SizedBox(height: 10), // Espacio vertical entre los botones
                        ElevatedButton(
                          onPressed: () {
                            // Implementar la navegación a la pantalla de preferencias de búsqueda aquí
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPreferencesPage()));
                          },
                          child: Text('Preferencias de búsqueda'),
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

class ModificacionForm extends StatefulWidget { // Cambio de UserProfileForm a ModificacionForm
  @override
  _ModificacionFormState createState() => _ModificacionFormState();
}

class _ModificacionFormState extends State<ModificacionForm> { // Cambio de _UserProfileFormState a _ModificacionFormState
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _edadController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  String? _selectedSex;
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
            controller: _edadController,
            decoration: InputDecoration(
              labelText: 'Fecha de nacimiento',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su fecha de nacimiento';
              }
              final DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(value);
              final DateTime currentDate = DateTime.now();
              final DateTime minDate = DateTime(currentDate.year - 18, currentDate.month, currentDate.day);
              if (selectedDate.isAfter(minDate)) {
                return 'Debe ser mayor de 18 años';
              }
              return null;
            },
            onTap: () async {
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
          DropdownButtonFormField<String>(
            value: _selectedSex,
            onChanged: (newValue) {
              setState(() {
                _selectedSex = newValue;
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
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
