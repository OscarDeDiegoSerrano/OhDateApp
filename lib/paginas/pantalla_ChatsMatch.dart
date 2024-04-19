import 'package:flutter/material.dart';
import 'package:ohdate_app/paginas/inicio.dart';
import 'package:ohdate_app/paginas/pantalla_chat.dart';

class PantallaChatsMatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
                child: Image.asset(
                  'lib/imatges/LogoOhDate.png',
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaginaChat(emailAmbQuiParlem: '', idReceptor: '',)),
                          );
                        },
                        child: Container(
                          color: const Color.fromARGB(255, 247, 150, 230),
                          child: const Center(
                            child: Text(
                              'Conversaciones',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 119, 231, 123),
                        child: const Center(
                          child: Text(
                            'Matches',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantallaChatsMatch()),
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
                      // Acción al presionar el botón de ajustes
                    },
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
