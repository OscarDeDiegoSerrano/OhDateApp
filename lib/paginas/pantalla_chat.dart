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
    controllerScroll.dispose();  // Dispose the scroll controller
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => ferScrollCapAvall(),
      );
    });
  }

  void ferScrollCapAvall() {
    if (controllerScroll.hasClients) {
      controllerScroll.animateTo(
        controllerScroll.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
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
          return const Text("Error cargando mensajes.");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        if (data == null || data.docs.isEmpty) {
          return const Center(child: Text("No hay mensajes."));
        }
        return ListView.builder(
          controller: controllerScroll,
          itemCount: data.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot document = data.docs[index];
            final Map<String, dynamic> messageData = document.data() as Map<String, dynamic>;
            final bool isCurrentUser = messageData["idAutor"] == idUsuariActual;
            final Timestamp timestamp = messageData["timestamp"];
            return _construirItemMissatge(messageData["missatge"], isCurrentUser, timestamp);
          },
        );
      },
    );
  }

  Widget _construirItemMissatge(String message, bool isCurrentUser, Timestamp timestamp) {
    var aliniament = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    var colorBombolla = isCurrentUser ? const Color.fromARGB(255, 236, 116, 210) : const Color.fromARGB(255, 255, 255, 255);
    var formattedTime = "${timestamp.toDate().hour}:${timestamp.toDate().minute}";
    var formattedDate = "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: aliniament,
          child: BombollaMissatge(
            colorBombolla: colorBombolla ?? Colors.black,
            missatge: message,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Añadir padding horizontal
          child: Row(
            mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                formattedTime,
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 12.0),
              ),
              const SizedBox(width: 4.0),
              Text(
                formattedDate,
                style: TextStyle(color: const Color.fromARGB(255, 2, 2, 2), fontSize: 12.0),
              ),
            ],
          ),
        ),
      ],
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
              decoration: const InputDecoration(
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
                const Color.fromARGB(255, 228, 88, 233),
              ),
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
