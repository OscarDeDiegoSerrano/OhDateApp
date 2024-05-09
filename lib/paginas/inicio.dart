import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ohdate_app/servicios/servicio_autentificacion.dart';
import 'package:ohdate_app/paginas/ModificarDatosUsuario.dart';
import 'package:ohdate_app/paginas/login.dart';
import 'package:ohdate_app/paginas/pantalla_ChatsMatch.dart';
import 'package:ohdate_app/paginas/preferenciaBusqueda.dart';

class PaginaInicio extends StatefulWidget {
  @override
  _PaginaInicioState createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  User? usuarioActual = FirebaseAuth.instance.currentUser;
  late String nombre;

  @override
  void initState() {
    super.initState();
    // Obtener el nombre del usuario actual
    if (usuarioActual != null) {
      obtenerNombreUsuario();
    }
  }

  // Función para obtener el nombre del usuario desde Firestore
  Future<void> obtenerNombreUsuario() async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('usuarios').doc(usuarioActual!.uid).get();
    setState(() {
      nombre = document['nombre'];
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
                    leading: Icon(Icons.account_circle), // Icono de perfil
                    title: Text('Perfil'),
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
                    leading: Icon(Icons.logout), // Icono de cerrar sesión
                    title: Text('Cerrar Sesión'),
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
                SwipeCardPage(),
              ],
            ),
          ),
          BottomAppBar(
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
  @override
  _SwipeCardPageState createState() => _SwipeCardPageState();
}

class _SwipeCardPageState extends State<SwipeCardPage> {
  List<Map<String, dynamic>> usersData = [];
  int currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    // Cargar los datos de usuarios cuando se inicia el widget
    loadUsers();
  }

  Future<void> loadUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('usuarios');
    QuerySnapshot querySnapshot = await users.get();
    querySnapshot.docs.forEach((doc) {
      usersData.add({
        'name': doc['nombre'] ?? '', // Obtener el nombre del usuario, asegurándose de que no sea nulo
        'photoUrl': '', // Inicialmente, establecer la URL de la foto del usuario como vacía
        'uid': doc.id, // Obtener el UID del usuario
      });
    });

    // Obtener las URLs de las imágenes de los usuarios
    await getUsersPhotoUrls();
  }

  Future<void> getUsersPhotoUrls() async {
    for (int i = 0; i < usersData.length; i++) {
      // Obtener la URL de la imagen del usuario
      String photoUrl = await FirebaseStorage.instance.ref().child('${usersData[i]['uid']}/avatar/${usersData[i]['uid']}').getDownloadURL();
      // Actualizar la URL de la foto del usuario en la lista
      setState(() {
        usersData[i]['photoUrl'] = photoUrl;
      });
    }
  }

  void swipeLeft() {
    setState(() {
      currentPhotoIndex = (currentPhotoIndex + 1) % usersData.length;
    });
  }

  void swipeRight() {
    setState(() {
      currentPhotoIndex = (currentPhotoIndex - 1 + usersData.length) % usersData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final sensitivity = 20.0;
        if (details.delta.dx.abs() > sensitivity) {
          if (details.delta.dx > 0) {
            swipeRight();
          } else if (details.delta.dx < 0) {
            swipeLeft();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 228, 139, 194)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: usersData.isEmpty
                ? Center(child: CircularProgressIndicator()) // Indicador de carga mientras se cargan los datos
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
                          style: TextStyle(
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
    );
  }
}
