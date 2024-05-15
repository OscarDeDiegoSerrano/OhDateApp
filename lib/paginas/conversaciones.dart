import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ohdate_app/paginas/inicio.dart';
import 'package:ohdate_app/paginas/preferenciaBusqueda.dart';

class Conversaciones extends StatelessWidget {
  final User usuarioActual = FirebaseAuth.instance.currentUser!;

  // Función para obtener la lista de nombres de usuarios desde Firestore
  Stream<List<String>> obtenerNombresUsuarios() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioActual.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return List<String>.from(data['listaConversaciones'] ?? []);
      }
      return [];
    });
  }

  Future<void> eliminarUsuarioDeConversaciones(String nombreUsuario) async {
    DocumentReference usuarioDocRef = FirebaseFirestore.instance.collection('usuarios').doc(usuarioActual.uid);
    DocumentSnapshot usuarioSnapshot = await usuarioDocRef.get();

    if (usuarioSnapshot.exists) {
      List<String> listaConversaciones = List<String>.from(usuarioSnapshot['listaConversaciones']);
      listaConversaciones.remove(nombreUsuario);

      await usuarioDocRef.update({
        'listaConversaciones': listaConversaciones,
      });
    }
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
          return ListView.builder(
            itemCount: listaConversaciones.length,
            itemBuilder: (context, index) {
              String nombreUsuario = listaConversaciones[index];
              return ListTile(
                title: Text(nombreUsuario),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    await eliminarUsuarioDeConversaciones(nombreUsuario);
                  },
                ),
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
