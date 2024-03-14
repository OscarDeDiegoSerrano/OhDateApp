import 'package:flutter/material.dart';


class PaginaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OhDate'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SwipeCardPage(),
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
  List<String> photos = ['foto1', 'foto2', 'foto3']; // Tus fotos aquí
  int currentPhotoIndex = 0;

  void swipeLeft() {
    setState(() {
      currentPhotoIndex = (currentPhotoIndex + 20) % photos.length;
    });
  }

  void swipeRight() {
    setState(() {
      
      currentPhotoIndex = (currentPhotoIndex - 20) % photos.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          swipeRight();
        } else if (details.delta.dx < 0) {
          swipeLeft();
        }
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            'assets/${photos[currentPhotoIndex]}.jpg', // Ajusta la ruta de la imagen según tu estructura de archivos
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
