import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    User? usuarioActual = ServicioAutenticacion().getUsuariActual();
    String nombre = usuarioActual?.email ?? 'Invitado';
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
  List<String> photos = [
    'lib/imatges/imagen1.jpg',
    'lib/imatges/imagen2.jpg',
    'lib/imatges/imagen3.jpg'
  ];
  int currentPhotoIndex = 0;

  void swipeLeft() {
    setState(() {
      currentPhotoIndex = (currentPhotoIndex + 1) % photos.length;
    });
  }

  void swipeRight() {
    setState(() {
      currentPhotoIndex = (currentPhotoIndex - 1 + photos.length) % photos.length;
    });
  }

  @override
   @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Define una sensibilidad personalizada para el swipe
        final sensitivity = 20.0;

        // Si el cambio en la coordenada X es mayor que la sensibilidad definida
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
            child: Image.asset(
              '${photos[currentPhotoIndex]}',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}