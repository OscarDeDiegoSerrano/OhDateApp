import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/login.dart';

class PaginaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          // Icono de perfil que abre el menú desplegable
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Hola, [Nombre de Usuario]'), // Puedes colocar el nombre de usuario aquí
                  enabled: false,
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.person), // Icono de perfil
                    title: Text('Perfil'),
                    onTap: () {
                      // Acción al seleccionar "Perfil"
                      // Puedes redirigir a la página de perfil aquí
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
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SwipeCardPage(),
                Positioned(
                  top: 10.0,
                  child: Image.asset(
                    'lib/imatges/LogoOhDate.png',
                    width: 60.0,
                  ),
                ),
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
                    // Acción al presionar el botón de chats
                  },
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    // Acción al presionar el botón de inicio
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
          child: Image.asset(
            '${photos[currentPhotoIndex]}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
