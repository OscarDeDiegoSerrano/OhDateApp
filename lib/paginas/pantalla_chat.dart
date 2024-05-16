import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohdate_app/servicios/servicio_autentificacion.dart';
import 'package:ohdate_app/components/bombolla_missatge.dart';
import 'package:ohdate_app/servicios/servei_chat.dart';

class PaginaChat extends StatefulWidget {
  final String emailAmbQuiParlem;
  final String idReceptor;
  final String nombreUsuario;
  final String salaId;  // Agregar este parámetro

  const PaginaChat({
    Key? key,
    required this.emailAmbQuiParlem,
    required this.idReceptor,
    required this.nombreUsuario,
    required this.salaId,  // Agregar este parámetro
  }) : super(key: key);

  @override
  State<PaginaChat> createState() => _PaginaChatState();
}

class _PaginaChatState extends State<PaginaChat> {
  final TextEditingController controllerMissatge = TextEditingController();
  final ScrollController controllerScroll = ScrollController();

  final ServeiChat _serveiChat = ServeiChat();
  final ServicioAutenticacion servicioAutenticacion = ServicioAutenticacion();

  // Variable pel teclat d'un mòbil.
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    controllerMissatge.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => ferScrollCapAvall(),
      );
    });

    // Ens esperem un moment, i llavors movem cap a baix.
    Future.delayed(
      const Duration(milliseconds: 500),
      () => ferScrollCapAvall(),
    );
  }

  void ferScrollCapAvall() {
    controllerScroll.animateTo(
      controllerScroll.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void enviarMissatge() async {
    if (controllerMissatge.text.isNotEmpty) {
      // Enviar el missatge.
      await _serveiChat.enviarMissatge(
        widget.idReceptor,
        controllerMissatge.text,
        widget.salaId,  // Pasar el ID de la sala
      );

      // Netejar el camp.
      controllerMissatge.clear();
    }
    ferScrollCapAvall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.emailAmbQuiParlem),
      ),
      body: Column(
        children: [
          // Zona missatges.
          Expanded(
            child: _construirLlistaMissatges(),
          ),

          // Zona escriure missatge.
          _construirZonaInputUsuari(),
        ],
      ),
    );
  }

  Widget _construirLlistaMissatges() {
    String idUsuariActual = ServicioAutenticacion().getUsuariActual()!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _serveiChat.getMissatges(idUsuariActual, widget.idReceptor, widget.salaId),  // Pasar el ID de la sala
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error cargando mensajes.");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        if (data == null || data.docs.isEmpty) {
          return Center(child: Text("No hay mensajes."));
        }
        return ListView.builder(
          controller: controllerScroll,
          itemCount: data.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot document = data.docs[index];
            final Map<String, dynamic> messageData = document.data() as Map<String, dynamic>;
            final bool isCurrentUser = messageData["idAutor"] == idUsuariActual;
            return _construirItemMissatge(messageData["missatge"], isCurrentUser);
          },
        );
      },
    );
  }

  Widget _construirItemMissatge(String message, bool isCurrentUser) {
    var aliniament = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    var colorBombolla = isCurrentUser ? Color.fromARGB(255, 236, 116, 210) : const Color.fromARGB(255, 255, 255, 255);
    return Container(
      alignment: aliniament,
      child: BombollaMissatge(
        colorBombolla: colorBombolla ?? Colors.black,
        missatge: message,
      ),
    );
  }

  Widget _construirZonaInputUsuari() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controllerMissatge,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                hintText: "Escriu el missatge...",
                ),
                ),
                ),
                const SizedBox(
                width: 10,
                ),
                IconButton(
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 228, 88, 233)),
                ),
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: enviarMissatge,
                ),
        ],
              ),
                );
                }
                }
