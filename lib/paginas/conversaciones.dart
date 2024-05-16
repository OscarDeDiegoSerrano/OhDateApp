import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ohdate_app/paginas/inicio.dart';
import 'package:ohdate_app/paginas/pantalla_chat.dart';
import 'package:ohdate_app/paginas/preferenciaBusqueda.dart';
import 'package:ohdate_app/servicios/servei_chat.dart';

class Conversaciones extends StatelessWidget {
  final User usuarioActual = FirebaseAuth.instance.currentUser!;

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

  Future<void> crearSalaDeChat(BuildContext context, String nombreUsuario) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('nombre', isEqualTo: nombreUsuario)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot receptorDoc = querySnapshot.docs.first;
      String idReceptor = receptorDoc.id;
      String emailReceptor = receptorDoc['email'];

      ServeiChat serveiChat = ServeiChat();
      String salaId = await serveiChat.crearNovaSalaDeChat(idReceptor);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaginaChat(
            emailAmbQuiParlem: emailReceptor,
            idReceptor: idReceptor,
            nombreUsuario: nombreUsuario,
            salaId: salaId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'lib/imatges/LogoOhDate.png',
              width: 40,
              height: 40,
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(usuarioActual.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Cargando...');
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                var userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                String nombreUsuario = userData['nombre'] ?? 'Usuario';
                return Text('Hola, $nombreUsuario');
              },
            ),
          ],
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 143, 206),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(nombreUsuario),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chat),
                          onPressed: () {
                            crearSalaDeChat(context, nombreUsuario);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () async {
                            await eliminarUsuarioDeConversaciones(nombreUsuario);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/pantalla_chat.dart',
                        arguments: nombreUsuario,
                      );
                    },
                  ),
                ),
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
