import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/inicio.dart';
import 'package:ohdate_app/paginas/pantalla_ChatsMatch.dart';

class Conversaciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversaciones'),
        leading: Image.asset(
          'lib/imatges/LogoOhDate.png',
          width: 40,
          height: 40,
        ),
      ),
      body: Container(
        child: StreamBuilder<List<String>>(
          stream: obtenerNombresUsuarios(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Carregant dades...'));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Muestra la lista de nombres de usuario
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  String nombreUsuario = snapshot.data![index];
                  return ListTile(
                    title: Text(nombreUsuario),
                    onTap: () {
                      // Redirige a la pantalla de chat al hacer clic en un usuario
                      Navigator.pushNamed(
                        context,
                        '/pantallaChat',
                        arguments: nombreUsuario,
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaChatsMatch()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaInicio()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Acción al presionar el botón de ajustes
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
