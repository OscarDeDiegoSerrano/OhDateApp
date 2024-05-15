import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ohdate_app/paginas/ModificarDatosUsuario.dart';
import 'package:ohdate_app/paginas/conversaciones.dart';
import 'package:ohdate_app/paginas/login.dart';
import 'package:ohdate_app/paginas/preferenciaBusqueda.dart';

class PaginaInicio extends StatefulWidget {
  @override
  _PaginaInicioState createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  User? usuarioActual = FirebaseAuth.instance.currentUser;
  late String nombre;
  List<String> listaConversaciones = [];

  @override
  void initState() {
    super.initState();
    // Obtener el nombre del usuario actual
    if (usuarioActual != null) {
      obtenerNombreUsuario();
      obtenerListaConversaciones();
    }
  }

  // Función para obtener el nombre del usuario desde Firestore
  Future<void> obtenerNombreUsuario() async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('usuarios').doc(usuarioActual!.uid).get();
    setState(() {
      nombre = document['nombre'];
    });
  }

  // Función para obtener la lista de conversaciones del usuario desde Firestore
  Future<void> obtenerListaConversaciones() async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('usuarios').doc(usuarioActual!.uid).get();
    setState(() {
      listaConversaciones = List<String>.from(document['listaConversaciones'] ?? []);
    });
  }

  // Callback function to update the list of conversations
  void updateConversations(String userName) {
    setState(() {
      listaConversaciones.add(userName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'lib/imatges/LogoOhDate.png',
            width: 60.0,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Hola, $nombre"), // Mostrar el nombre de usuario aquí
                  enabled: false,
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.account_circle), // Icono de perfil
                    title: const Text('Perfil'),
                    onTap: () {
                      // Navegar a la página ModificarDatosUsuario
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ModificarDatosUsuario()),
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.logout), // Icono de cerrar sesión
                    title: const Text('Cerrar Sesión'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => IniciarSesion()),
                      );
                    },
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SwipeCardPage(updateConversations, listaConversaciones), // Pass both callback function and listaConversaciones
              ],
            ),
          ),
          BottomAppBar(
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
        ],
      ),
    );
  }
}

class SwipeCardPage extends StatefulWidget {
  final Function(String) updateConversations;
  final List<String> listaConversaciones;

  SwipeCardPage(this.updateConversations, this.listaConversaciones);

  @override
  _SwipeCardPageState createState() => _SwipeCardPageState();
}

class _SwipeCardPageState extends State<SwipeCardPage> {
  List<Map<String, dynamic>> usersData = [];
  int currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load user data when widget is initialized
    loadUsers();
  }

  Future<void> loadUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('usuarios');
    QuerySnapshot querySnapshot = await users.get();
    querySnapshot.docs.forEach((doc) {
      usersData.add({
        'name': doc['nombre'] ?? '',
        'photoUrl': '',
        'uid': doc.id,
      });
    });

    // Mezclar la lista de usuarios para obtener un orden aleatorio
    usersData.shuffle(Random());

    // Get users' photo URLs
    await getUsersPhotoUrls();
  }

  Future<void> getUsersPhotoUrls() async {
    for (int i = 0; i < usersData.length; i++) {
      String? photoUrl;
      try {
        photoUrl = await FirebaseStorage.instance.ref().child('${usersData[i]['uid']}/avatar/${usersData[i]['uid']}').getDownloadURL();
      } catch (e) {
        print('Error obteniendo la URL de la foto del usuario: $e');
      }
      setState(() {
        usersData[i]['photoUrl'] = photoUrl ?? '';
      });
    }
  }

  Future<void> agregarCampoListaConversaciones(String documentId, List<String> ids) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('usuarios').doc(documentId);
    await documentReference.update({
      'listaConversaciones': ids,
    });
  }

  void swipeLeft() {
    setState(() {
      currentPhotoIndex = (currentPhotoIndex + 1) % usersData.length;
    });
  }

  void swipeRight() async {
    String userName = usersData[currentPhotoIndex]['name'];
    if (!widget.listaConversaciones.contains(userName)) {
      widget.listaConversaciones.add(userName);

      await agregarCampoListaConversaciones(FirebaseAuth.instance.currentUser!.uid, widget.listaConversaciones);

      widget.updateConversations(userName);
    }

    setState(() {
      currentPhotoIndex = (currentPhotoIndex + 1) % usersData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              final sensitivity = 20.0;
              if (details.delta.dx.abs() > sensitivity) {
                if (details.delta.dx > 0) {
                  swipeRight(); // Swipe to the right
                } else if (details.delta.dx < 0) {
                  swipeLeft(); // Swipe to the left
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 228, 139, 194)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: usersData.isEmpty
                      ? const Center(child: CircularProgressIndicator()) // Loading indicator while data is loading
                      : Stack(
                          children: [
                            Image.network(
                              usersData[currentPhotoIndex]['photoUrl'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                usersData[currentPhotoIndex]['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 40),
              onPressed: swipeLeft,
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green, size: 40),
              onPressed: swipeRight,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}