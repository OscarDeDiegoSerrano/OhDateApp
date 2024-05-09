import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/inicio.dart';
import 'package:ohdate_app/paginas/preferenciaBusqueda.dart';

class Conversaciones extends StatelessWidget {
  // Función para obtener la lista de nombres de usuarios desde Firestore
  Stream<List<String>> obtenerNombresUsuarios() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .snapshots()
        .map((snapshot) {
      List<String> nombres = [];
      snapshot.docs.forEach((doc) {
        nombres.add(doc['nombre']);
      });
      return nombres;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversaciones'),
        leading: Image.asset(
          'lib/imatges/LogoOhDate.png',
          width: 40,
          height: 40,
        ),
      ),
      body: StreamBuilder<List<String>>(
        stream: obtenerNombresUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<String> listaConversaciones = snapshot.data ?? [];
          return Container(
            child: ListView.builder(
              itemCount: listaConversaciones.length,
              itemBuilder: (context, index) {
                String nombreUsuario = listaConversaciones[index];
                return ListTile(
                  title: Text(nombreUsuario),
                  onTap: () {
                    // Redirige a la pantalla de chat al hacer clic en un usuario
                    Navigator.pushNamed(
                      context,
                      '/pantalla_chat.dart',
                      arguments: nombreUsuario,
                    );
                  },
                );
              },
            ),
          );
        },
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreferenciaBusqueda()),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}



Stream<List<String>> obtenerNombresUsuarios() {
  return FirebaseFirestore.instance
      .collection('OhDate')
      .doc('usuarios')
      .snapshots()
      .map((snapshot) {
    List<String> nombres = [];
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        nombres.add(value['nombre']);
      });
    }
    return nombres;
  });
}
